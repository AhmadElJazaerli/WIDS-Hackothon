import 'package:flutter/material.dart';

class OutputScreen extends StatelessWidget {
  const OutputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final results = [
      {
        "Material": "Hemp Blocks + Timber",
        "Cost": "\$14,800",
        "CO2": "8.9 t",
        "Build Time": "34 days",
        "Energy": "B+",
        "Score": "86/100"
      },
      {
        "Material": "Recycled Concrete + PVC Roof",
        "Cost": "\$13,500",
        "CO2": "10.2 t",
        "Build Time": "38 days",
        "Energy": "C",
        "Score": "74/100"
      },
    ];

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Card(
            color: Colors.white,
            elevation: 6,
            shadowColor: Colors.green.withOpacity(0.2),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Optimization Results",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.green.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor:
                      MaterialStateProperty.all(Colors.green.shade100),
                      dataRowColor:
                      MaterialStateProperty.all(Colors.green.shade50),
                      columns: const [
                        DataColumn(label: Text("Material Combo")),
                        DataColumn(label: Text("Cost")),
                        DataColumn(label: Text("CO₂")),
                        DataColumn(label: Text("Build Time")),
                        DataColumn(label: Text("Energy")),
                        DataColumn(label: Text("Score")),
                      ],
                      rows: results.map((row) {
                        return DataRow(
                          cells: [
                            DataCell(Text(row["Material"]!)),
                            DataCell(Text(row["Cost"]!)),
                            DataCell(Text(row["CO2"]!)),
                            DataCell(Text(row["Build Time"]!)),
                            DataCell(Text(row["Energy"]!)),
                            DataCell(Text(row["Score"]!)),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
