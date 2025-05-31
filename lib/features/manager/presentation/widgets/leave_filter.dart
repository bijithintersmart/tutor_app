import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LeaveFilter extends StatefulWidget {
  final List<String> teacherNames;
  final String? selectedTeacher;
  final DateTime? startDate;
  final DateTime? endDate;
  final ValueChanged<String?> onTeacherChanged;
  final ValueChanged<DateTime?> onStartDateChanged;
  final ValueChanged<DateTime?> onEndDateChanged;
  final VoidCallback onClearFilters;

  const LeaveFilter({
    super.key,
    required this.teacherNames,
    required this.selectedTeacher,
    required this.startDate,
    required this.endDate,
    required this.onTeacherChanged,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.onClearFilters,
  });

  @override
  State<LeaveFilter> createState() => _LeaveFilterState();
}

class _LeaveFilterState extends State<LeaveFilter> {
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
              'Filter Leave Requests',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Teacher',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              value: widget.selectedTeacher,
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('All Teachers'),
                ),
                ...widget.teacherNames.map(
                  (name) =>
                      DropdownMenuItem<String>(value: name, child: Text(name)),
                ),
              ],
              onChanged: widget.onTeacherChanged,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: widget.startDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) {
                        widget.onStartDateChanged(picked);
                      }
                    },
                    child: Text(
                      widget.startDate != null
                          ? DateFormat('MMM dd, yyyy').format(widget.startDate!)
                          : 'Start Date',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: widget.endDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) {
                        widget.onEndDateChanged(picked);
                      }
                    },
                    child: Text(
                      widget.endDate != null
                          ? DateFormat('MMM dd, yyyy').format(widget.endDate!)
                          : 'End Date',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: widget.onClearFilters,
                child: const Text('Clear Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
