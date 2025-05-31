import 'package:flutter/material.dart';
import 'package:tutor_app/features/manager/data/models/leave_request_model.dart';
import 'package:tutor_app/features/manager/presentation/widgets/leave_request_card.dart';

class LeaveList extends StatelessWidget {
  final List<ManagerLeaveRequest> requests;
  final bool showActions;
  final Function(String)? onApprove;
  final Function(String)? onReject;

  const LeaveList({
    super.key,
    required this.requests,
    this.showActions = false,
    this.onApprove,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return requests.isEmpty
        ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.event_busy,
                size: 64,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              Text(
                'No requests found',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        )
        : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];
            return AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(milliseconds: 300),
              child: ManagerLeaveRequestCard(
                request: request,
                onApprove:
                    showActions ? () => onApprove?.call(request.id) : null,
                onReject: showActions ? () => onReject?.call(request.id) : null,
              ),
            );
          },
        );
  }
}
