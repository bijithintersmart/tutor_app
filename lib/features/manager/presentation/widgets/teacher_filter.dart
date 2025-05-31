import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TeacherFilter extends StatefulWidget {
  final DateTime selectedDate;
  final List<String> subjectFilters;
  final List<String> allSubjects;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<List<String>> onSubjectFiltersChanged;

  const TeacherFilter({
    super.key,
    required this.selectedDate,
    required this.subjectFilters,
    required this.allSubjects,
    required this.onDateChanged,
    required this.onSubjectFiltersChanged,
  });

  @override
  State<TeacherFilter> createState() => _TeacherFilterState();
}

class _TeacherFilterState extends State<TeacherFilter> {
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
            Text(
              'Filter Teachers',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Available on: ${DateFormat('MMM dd, yyyy').format(widget.selectedDate)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: widget.selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 60)),
                    );
                    if (picked != null) {
                      widget.onDateChanged(picked);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Change Date'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Filter by Subject:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  widget.allSubjects.map((subject) {
                    final isSelected = widget.subjectFilters.contains(subject);
                    return FilterChip(
                      label: Text(subject),
                      selected: isSelected,
                      onSelected: (selected) {
                        final newFilters = List<String>.from(
                          widget.subjectFilters,
                        );
                        if (selected) {
                          newFilters.add(subject);
                        } else {
                          newFilters.remove(subject);
                        }
                        widget.onSubjectFiltersChanged(newFilters);
                      },
                      backgroundColor:
                          Theme.of(context).colorScheme.surfaceContainer,
                      selectedColor:
                          Theme.of(context).colorScheme.primaryContainer,
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
