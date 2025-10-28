# =====================================================
# Low-Cost Housing Configurator – Training + Validation
# =====================================================
import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split, cross_val_score
from sklearn.preprocessing import MinMaxScaler, OneHotEncoder
from sklearn.ensemble import RandomForestClassifier, RandomForestRegressor, GradientBoostingRegressor, VotingRegressor
from sklearn.metrics import accuracy_score, mean_absolute_error, mean_squared_error, r2_score
import joblib
import warnings
warnings.filterwarnings("ignore")

# =====================================================
# 1. Load Data
# =====================================================
df = pd.read_csv("data.csv")
materials_ref = pd.read_csv("materials_curated.csv")

print(f"✅ Loaded {len(df)} samples.")
print(df.head(3))

# =====================================================
# 2. Map Materials → Standard Categories
# =====================================================
combo_to_stdcat = {
    "timber_frame_concrete_slab": "timber",
    "concrete_shell_timber_roof": "concrete",
    "all_concrete": "concrete",
    "all_timber": "timber"
}
df["std_category"] = df["material_combo"].map(combo_to_stdcat)

# =====================================================
# 3. Merge Material Averages
# =====================================================
mat_summary = materials_ref.groupby("std_category").agg({
    "gwp_kgco2e_per_kg": "mean",
    "density_kg_per_m3": "mean",
    "build_speed": "mean"
}).reset_index()
mat_summary.columns = ["std_category", "avg_gwp", "avg_density", "avg_speed"]
df = df.merge(mat_summary, on="std_category", how="left")

# =====================================================
# 4. Handle NaNs
# =====================================================
for col in df.select_dtypes(include=[np.number]).columns:
    df[col].fillna(df[col].median(), inplace=True)
for col in df.select_dtypes(include=["object"]).columns:
    df[col].fillna(df[col].mode()[0], inplace=True)
print("✅ Cleaned NaN values.")

# =====================================================
# 5. Feature Prep
# =====================================================
num_features = ["building_size_m2", "avg_gwp", "avg_density", "avg_speed"]
cat_features = ["location", "budget_level"]

X_num = df[num_features].values
X_cat = df[cat_features].astype(str).values

num_scaler = MinMaxScaler()
X_num_scaled = num_scaler.fit_transform(X_num)

ohe = OneHotEncoder(sparse_output=False, handle_unknown='ignore')
X_cat_ohe = ohe.fit_transform(X_cat)

X = np.hstack([X_num_scaled, X_cat_ohe])
y_material = df["material_combo"].astype("category").cat.codes.values
y_cost = np.log1p(df["est_cost_usd"].values)

X_train, X_test, y_mat_train, y_mat_test, y_cost_train, y_cost_test, df_train, df_test = train_test_split(
    X, y_material, y_cost, df, test_size=0.2, random_state=42
)

print(f"✅ Training samples: {len(X_train)}, Test samples: {len(X_test)}")

# =====================================================
# 6. Train Models
# =====================================================
clf_rf = RandomForestClassifier(n_estimators=300, class_weight='balanced', random_state=42)
reg_rf = RandomForestRegressor(n_estimators=300, random_state=42)
reg_gb = GradientBoostingRegressor(n_estimators=400, learning_rate=0.05, subsample=0.9, random_state=42)

print("\n🏗️ Training classifier...")
clf_rf.fit(X_train, y_mat_train)

print("💰 Training regressors...")
reg_rf.fit(X_train, y_cost_train)
reg_gb.fit(X_train, y_cost_train)

ensemble_reg = VotingRegressor([("rf", reg_rf), ("gb", reg_gb)])
ensemble_reg.fit(X_train, y_cost_train)

# =====================================================
# 7. Validation
# =====================================================
print("\n🧪 VALIDATION (Held-out Test Data)")
y_mat_pred = clf_rf.predict(X_test)
y_cost_pred = np.expm1(ensemble_reg.predict(X_test))
y_cost_true = np.expm1(y_cost_test)

val_acc = accuracy_score(y_mat_test, y_mat_pred)
mae = mean_absolute_error(y_cost_true, y_cost_pred)
rmse = np.sqrt(mean_squared_error(y_cost_true, y_cost_pred))
r2 = r2_score(y_cost_true, y_cost_pred)

print(f"🏗️ Validation Material Accuracy: {val_acc * 100:.2f}%")
print(f"💰 Validation Cost MAE: {mae:.2f} USD")
print(f"💰 Validation Cost RMSE: {rmse:.2f} USD")
print(f"📊 Validation R² Score: {r2:.3f}")

# =====================================================
# 8. Save Models
# =====================================================
os.makedirs("lchc_models", exist_ok=True)
joblib.dump(clf_rf, "lchc_models/best_material_clf.joblib")
joblib.dump(ensemble_reg, "lchc_models/best_cost_reg.joblib")
joblib.dump(num_scaler, "lchc_models/num_scaler.joblib")
joblib.dump(ohe, "lchc_models/ohe.joblib")
joblib.dump(dict(enumerate(df["material_combo"].astype("category").cat.categories)), "lchc_models/material_map.joblib")
print("✅ Models and encoders saved to ./lchc_models")

# =====================================================
# 9. Plot for quick check
# =====================================================
plt.scatter(y_cost_true, y_cost_pred, alpha=0.6, color="#0077b6")
plt.plot([y_cost_true.min(), y_cost_true.max()], [y_cost_true.min(), y_cost_true.max()], "r--")
plt.xlabel("True Cost (USD)")
plt.ylabel("Predicted Cost (USD)")
plt.title("Validation: Predicted vs True Cost")
plt.tight_layout()
plt.savefig("lchc_models/validation_scatter.png", dpi=150)
plt.show()

print("\n📈 Training complete. Ready for reuse.")
