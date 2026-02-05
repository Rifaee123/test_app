import 'package:flutter/material.dart';
import 'package:test_app/features/student/marks/presentation/pages/marks_keys.dart';

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
      key: MarksKeys.marksPage,
      appBar: AppBar(title: const Text('Final Marks')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          key: MarksKeys.marksList,
          child: DataTable(
            columnSpacing: 20,
            columns: const [
              DataColumn(label: Text('Subject')),
              DataColumn(label: Text('Int.')),
              DataColumn(label: Text('Final')),
              DataColumn(label: Text('Total')),
            ],
            rows: marks
                .asMap()
                .entries
                .map(
                  (entry) => DataRow(
                    key: ValueKey(MarksKeys.markItem(entry.key)),
                    cells: [
                      DataCell(Text(entry.value['subject'].toString())),
                      DataCell(Text(entry.value['internal'].toString())),
                      DataCell(Text(entry.value['final'].toString())),
                      DataCell(
                        Text(
                          entry.value['total'].toString(),
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
