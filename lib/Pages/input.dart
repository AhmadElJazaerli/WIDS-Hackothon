import 'package:flutter/material.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  RangeValues _budgetRange = const RangeValues(5000, 30000);

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final size = double.tryParse(_sizeController.text) ?? 0.0;
      final location = _locationController.text.trim();
      final budgetLow = _budgetRange.start;
      final budgetHigh = _budgetRange.end;

      debugPrint("🏠 Size: $size m²");
      debugPrint("📍 Location: $location");
      debugPrint("💰 Budget: \$${budgetLow.toStringAsFixed(0)} - \$${budgetHigh.toStringAsFixed(0)}");

      Navigator.pushReplacementNamed(context, '/output');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Inputs saved! Go to Output tab.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Card(
            color: Colors.green.shade50,
            elevation: 6,
            shadowColor: Colors.green.withOpacity(0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Project Input",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.green.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _sizeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Building Size (m²)",
                        prefixIcon: Icon(Icons.square_foot),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                      value == null || value.isEmpty ? "Enter a valid size" : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        labelText: "Location (e.g. Beirut / Rural)",
                        prefixIcon: Icon(Icons.location_on),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                      value == null || value.isEmpty ? "Enter a valid location" : null,
                    ),
                    const SizedBox(height: 25),
                    Text("Budget Range (USD)",
                        style: Theme.of(context).textTheme.titleMedium),
                    RangeSlider(
                      values: _budgetRange,
                      min: 1000,
                      max: 100000,
                      divisions: 50,
                      activeColor: Colors.green.shade700,
                      labels: RangeLabels(
                        "\$${_budgetRange.start.round()}",
                        "\$${_budgetRange.end.round()}",
                      ),
                      onChanged: (values) =>
                          setState(() => _budgetRange = values),
                    ),
                    const SizedBox(height: 30),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text("Predict"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
