import 'package:flutter/material.dart';
import 'package:tutor_app/features/teacher/data/models/leave_request.dart';

class StatusBadge extends StatelessWidget {
  final LeaveStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;

    switch (status) {
      case LeaveStatus.pending:
        color = Colors.amber;
        text = 'Pending';
        break;
      case LeaveStatus.approved:
        color = Colors.green;
        text = 'Approved';
        break;
      case LeaveStatus.rejected:
        color = Colors.red;
        text = 'Rejected';
        break;
    }

    return Chip(
      label: Text(
        text,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: color.withOpacity(0.2),
      side: BorderSide(color: color),
    );
  }
}
