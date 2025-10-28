# =====================================================
# Reusable Prediction Script
# =====================================================
import joblib
import numpy as np
import pandas as pd

def predict_material_and_cost(size_m2, location, budget_level):
    clf = joblib.load("lchc_models/best_material_clf.joblib")
    reg = joblib.load("lchc_models/best_cost_reg.joblib")
    num_scaler = joblib.load("lchc_models/num_scaler.joblib")
    ohe = joblib.load("lchc_models/ohe.joblib")
    materials_map = joblib.load("lchc_models/material_map.joblib")

    # proxy material averages
    avg_gwp, avg_density, avg_speed = 80, 1200, 0.8

    X_num = np.array([[size_m2, avg_gwp, avg_density, avg_speed]])
    X_cat = np.array([[location, budget_level]])
    X = np.hstack([num_scaler.transform(X_num), ohe.transform(X_cat)])

    mat_idx = clf.predict(X)[0]
    mat_name = materials_map[mat_idx]
    pred_cost = np.expm1(reg.predict(X)[0])

    return {"predicted_material": mat_name, "predicted_cost_usd": round(float(pred_cost), 2)}

if __name__ == "__main__":
    result = predict_material_and_cost(70, "urban", "medium")
    print("\n🔍 Example Prediction:", result)
