import 'package:flutter/material.dart';
import 'package:tutor_app/features/teacher/data/models/teacher_model.dart';

class TeacherProfileCard extends StatelessWidget {
  final Teacher teacher;

  const TeacherProfileCard({super.key, required this.teacher});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    teacher.name.substring(0, 1),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        teacher.name,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Teacher ID: ${teacher.id}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Subjects',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  teacher.subjects
                      .map(
                        (subject) => Chip(
                          label: Text(subject),
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                        ),
                      )
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
