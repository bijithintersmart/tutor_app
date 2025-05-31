import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tutor_app/features/teacher/data/models/teacher_model.dart';

class AvailabilityCard extends StatelessWidget {
  final Teacher teacher;
  final DateTime selectedDate;

  const AvailabilityCard({
    super.key,
    required this.teacher,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    final slots = teacher.availability[formattedDate] ?? [];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Availability on ${DateFormat('MMM dd, yyyy').format(selectedDate)}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            slots.isEmpty
                ? Text(
                  'No availability',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                )
                : Column(
                  children:
                      slots
                          .map(
                            (slot) => ListTile(
                              leading: const Icon(Icons.access_time),
                              title: Text(
                                '${slot.formattedStartTime} - ${slot.formattedEndTime}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
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
