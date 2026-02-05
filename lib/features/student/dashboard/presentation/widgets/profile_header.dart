import 'package:flutter/material.dart';
import 'package:test_app/core/entities/student.dart';
import 'package:test_app/core/test_ids.dart';

class ProfileHeader extends StatelessWidget {
  final Student student;

  const ProfileHeader({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 32,
                backgroundColor: Color(0xFF6366F1),
                child: Icon(Icons.person, color: Colors.white, size: 36),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(
                      label: TestIds.studentName,
                      child: Text(
                        student.name,
                        key: const ValueKey(TestIds.studentName),
                        style: const TextStyle(
                          color: Color(0xFF1E293B),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Semantics(
                        label: TestIds.studentIdLabel,
                        child: Text(
                          'ID: ${student.id}',
                          key: const ValueKey(TestIds.studentIdLabel),
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _DivisionBadge(division: student.division ?? "N/A"),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(height: 1),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _InfoColumn(
                key: const ValueKey(TestIds.parentName),
                label: 'Parent / Guardian',
                value: student.parentName ?? "Not Set",
                icon: Icons.family_restroom_outlined,
                testId: TestIds.parentName,
              ),
              _InfoColumn(
                key: const ValueKey(TestIds.studentSemester),
                label: 'Academic Term',
                value: student.semester ?? "Current",
                icon: Icons.menu_book_outlined,
                testId: TestIds.studentSemester,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DivisionBadge extends StatelessWidget {
  final String division;

  const _DivisionBadge({required this.division});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Semantics(
            label: TestIds.studentDivision,
            child: Text(
              division,
              key: const ValueKey(TestIds.studentDivision),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const Text(
            'CLASS',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoColumn extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final String? testId;

  const _InfoColumn({
    required this.label,
    required this.value,
    required this.icon,
    this.testId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF94A3B8)),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Semantics(
              label: testId,
              child: Text(
                value,
                key: testId != null ? ValueKey(testId) : null,
                style: const TextStyle(
                  color: Color(0xFF334155),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
