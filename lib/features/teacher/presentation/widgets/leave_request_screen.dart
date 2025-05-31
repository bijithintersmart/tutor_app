import 'package:flutter/material.dart';
import 'package:tutor_app/features/teacher/data/models/leave_request.dart';
import 'package:tutor_app/features/teacher/presentation/widgets/leave_request_card.dart';
import 'package:tutor_app/features/teacher/presentation/widgets/leave_request_dialog.dart';

class LeaveRequestScreen extends StatelessWidget {
  final List<LeaveRequest> pendingLeaveRequests;
  final List<LeaveRequest> pastLeaveRequests;
  final ValueChanged<LeaveRequest> onLeaveRequestAdded;

  const LeaveRequestScreen({
    super.key,
    required this.pendingLeaveRequests,
    required this.pastLeaveRequests,
    required this.onLeaveRequestAdded,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Material(
            color: Theme.of(context).colorScheme.surfaceContainer,
            child: TabBar(
              tabs: const [
                Tab(text: 'Pending Requests'),
                Tab(text: 'Past Requests'),
              ],
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor:
                  Theme.of(context).colorScheme.onSurfaceVariant,
              indicatorColor: Theme.of(context).colorScheme.primary,
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildLeaveRequestList(
                  context,
                  pendingLeaveRequests,
                  isPending: true,
                ),
                _buildLeaveRequestList(
                  context,
                  pastLeaveRequests,
                  isPending: false,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Request Leave'),
              onPressed:
                  () => showLeaveRequestDialog(context, onLeaveRequestAdded),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveRequestList(
    BuildContext context,
    List<LeaveRequest> requests, {
    required bool isPending,
  }) {
    if (requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isPending ? Icons.hourglass_empty : Icons.history,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              isPending
                  ? 'No pending leave requests'
                  : 'No past leave requests',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        return LeaveRequestCard(
          request: requests[index],
          onCancel:
              isPending
                  ? () {
                    // Implement cancel logic here
                  }
                  : null,
        );
      },
    );
  }
}
