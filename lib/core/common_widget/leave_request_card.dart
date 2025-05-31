import 'package:flutter/material.dart';

class LeaveRequestCard extends StatelessWidget {
  final LeaveRequest request;

  const LeaveRequestCard({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
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
                  '${_formatDate(request.fromDate)} - ${_formatDate(request.toDate)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                _buildStatusBadge(request.status),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Reason: ${request.reason}',
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Request ID: ${request.id}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                request.status == 'Pending'
                    ? TextButton(
                      onPressed: () {
                        // Logic to cancel request
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Request cancelled successfully'),
                          ),
                        );
                      },
                      child: const Text('Cancel Request'),
                    )
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;

    switch (status) {
      case 'Approved':
        bgColor = Colors.green[100]!;
        textColor = Colors.green[800]!;
        break;
      case 'Rejected':
        bgColor = Colors.red[100]!;
        textColor = Colors.red[800]!;
        break;
      case 'Pending':
      default:
        bgColor = Colors.orange[100]!;
        textColor = Colors.orange[800]!;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(status, style: TextStyle(color: textColor)),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

// Leave Request Model
class LeaveRequest {
  final String id;
  final String teacherName;
  final DateTime fromDate;
  final DateTime toDate;
  final String reason;
  String status;

  LeaveRequest({
    required this.id,
    required this.teacherName,
    required this.fromDate,
    required this.toDate,
    required this.reason,
    required this.status,
  });
}
