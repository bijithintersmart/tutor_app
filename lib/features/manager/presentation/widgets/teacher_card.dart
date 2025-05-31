import 'package:flutter/material.dart';
import 'package:tutor_app/features/teacher/data/models/teacher_model.dart';

class TeacherCard extends StatelessWidget {
  final Teacher teacher;
  final DateTime selectedDate;
  final VoidCallback onAssignPressed;
  final VoidCallback onViewPressed;

  const TeacherCard({
    super.key,
    required this.teacher,
    required this.selectedDate,
    required this.onAssignPressed,
    required this.onViewPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Text(
            teacher.name.substring(0, 1),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          teacher.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          teacher.subjects.join(', '),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                Icons.person_add,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: onAssignPressed,
              tooltip: 'Assign Student',
            ),
            IconButton(
              icon: Icon(
                Icons.visibility,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: onViewPressed,
              tooltip: 'View Profile',
            ),
          ],
        ),
        onTap: onViewPressed,
      ),
    );
  }
}
