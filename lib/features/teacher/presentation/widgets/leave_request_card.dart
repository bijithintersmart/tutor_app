import 'package:flutter/material.dart';
import 'package:tutor_app/features/teacher/data/models/leave_request.dart';
import 'package:tutor_app/features/teacher/presentation/widgets/status_badge.dart';
import 'package:tutor_app/features/teacher/presentation/widgets/info_row.dart';

class LeaveRequestCard extends StatelessWidget {
  final LeaveRequest request;
  final VoidCallback? onCancel;

  const LeaveRequestCard({super.key, required this.request, this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Leave Request',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                StatusBadge(status: request.status),
              ],
            ),
            const SizedBox(height: 16),
            InfoRow(
              icon: Icons.date_range,
              label: 'Date Range',
              value: request.formattedDateRange,
            ),
            InfoRow(
              icon: Icons.timelapse,
              label: 'Duration',
              value: '${request.durationInDays} day(s)',
            ),
            InfoRow(
              icon: Icons.subject,
              label: 'Reason',
              value: request.reason,
            ),
            if (request.comment != null)
              InfoRow(
                icon: Icons.comment,
                label: 'Comment',
                value: request.comment!,
              ),
            if (onCancel != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error,
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    child: const Text('Cancel Request'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
