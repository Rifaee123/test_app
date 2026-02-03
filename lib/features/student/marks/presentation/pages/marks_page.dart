import 'package:flutter/material.dart';

class MarksPage extends StatelessWidget {
  const MarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final marks = [
      {'subject': 'AI', 'internal': 22, 'final': 65, 'total': 87},
      {'subject': 'Mobile Dev', 'internal': 24, 'final': 70, 'total': 94},
      {'subject': 'Networks', 'internal': 18, 'final': 55, 'total': 73},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Final Marks')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: DataTable(
            columnSpacing: 20,
            columns: const [
              DataColumn(label: Text('Subject')),
              DataColumn(label: Text('Int.')),
              DataColumn(label: Text('Final')),
              DataColumn(label: Text('Total')),
            ],
            rows: marks
                .map(
                  (m) => DataRow(
                    cells: [
                      DataCell(Text(m['subject'].toString())),
                      DataCell(Text(m['internal'].toString())),
                      DataCell(Text(m['final'].toString())),
                      DataCell(
                        Text(
                          m['total'].toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
