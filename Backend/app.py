from flask import Flask, request, jsonify
from flask_cors import CORS
from predict_backend import predict_material_and_cost

app = Flask(__name__)
CORS(app)  # Allow Flutter frontend (or Postman, browser, etc.)

@app.route('/predict', methods=['GET'])
def predict():
    """
    Example call:
    GET /predict?size_m2=90&location=Beirut&budget_level=medium
    """
    try:
        # Extract query parameters
        size_m2 = float(request.args.get('size_m2', 0))
        location = request.args.get('location', '').strip()
        budget_level = request.args.get('budget_level', '').lower()

        # Validate input
        if not location or size_m2 <= 0:
            return jsonify({"error": "Invalid or missing parameters"}), 400

        # Call your logic
        result = predict_material_and_cost(size_m2, location, budget_level)
        return jsonify(result)

    except Exception as e:
        return jsonify({"error": str(e)}), 500


if __name__ == '__main__':
    app.run(debug=True)
