import 'package:flutter/material.dart';
import 'package:tutor_app/features/manager/presentation/widgets/teacher_card.dart';
import 'package:tutor_app/features/teacher/data/models/teacher_model.dart';
import 'package:tutor_app/features/teacher/presentation/pages/teacher_profile.dart';

class TeacherList extends StatelessWidget {
  final List<Teacher> teachers;
  final DateTime selectedDate;
  final VoidCallback onClearFilters;
  final Function(Teacher) onAssignPressed;

  const TeacherList({
    super.key,
    required this.teachers,
    required this.selectedDate,
    required this.onClearFilters,
    required this.onAssignPressed,
  });

  @override
  Widget build(BuildContext context) {
    return teachers.isEmpty
        ? Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 64,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              Text(
                'No teachers found matching your filters',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onClearFilters,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Clear Filters'),
              ),
            ],
          ),
        )
        : ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: teachers.length,
          itemBuilder: (context, index) {
            final teacher = teachers[index];
            return TeacherCard(
              teacher: teacher,
              selectedDate: selectedDate,
              onAssignPressed: () => onAssignPressed(teacher),
              onViewPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => TeacherProfileScreen(
                          teacher: teacher,
                          selectedDate: selectedDate,
                        ),
                  ),
                );
              },
            );
          },
        );
  }
}
