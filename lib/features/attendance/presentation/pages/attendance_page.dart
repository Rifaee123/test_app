import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:test_app/core/test_ids.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final attendanceData = [
      {'subject': 'Algorithms', 'percent': 0.85},
      {'subject': 'Databases', 'percent': 0.92},
      {'subject': 'Networking', 'percent': 0.65},
      {'subject': 'Software Eng.', 'percent': 0.78},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Attendance Overview')),
      body: Semantics(
        label: TestIds.attendanceList,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: attendanceData.length,
          itemBuilder: (context, index) {
            final data = attendanceData[index];
            final percent = data['percent'] as double;
            final isLow = percent < 0.75;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data['subject'] as String,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (isLow)
                          const Text(
                            'Low Attendance!',
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LinearPercentIndicator(
                      lineHeight: 8.0,
                      percent: percent,
                      progressColor: isLow ? Colors.red : Colors.blue,
                      backgroundColor: Colors.grey.shade100,
                      barRadius: const Radius.circular(8),
                      trailing: Text('${(percent * 100).toInt()}%'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
