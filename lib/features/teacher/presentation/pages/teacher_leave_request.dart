import 'package:flutter/material.dart';
import 'package:tutor_app/core/common_widget/custom_appbar.dart';
import 'package:tutor_app/core/common_widget/custom_drawer.dart';
import 'package:tutor_app/features/teacher/data/models/leave_request.dart';
import 'package:tutor_app/features/teacher/presentation/widgets/leave_request_card.dart';
import 'package:tutor_app/features/teacher/presentation/widgets/stat_card.dart';
import 'package:tutor_app/features/teacher/presentation/widgets/leave_request_dialog.dart';

class TeacherLeaveRequest extends StatefulWidget {
  const TeacherLeaveRequest({super.key});

  @override
  State<TeacherLeaveRequest> createState() => _TeacherLeaveRequestState();
}

class _TeacherLeaveRequestState extends State<TeacherLeaveRequest> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<LeaveRequest> myRequests = [
    LeaveRequest(
      id: '1',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 2)),
      reason: 'Medical appointment',
      status: LeaveStatus.pending,
    ),
    LeaveRequest(
      id: '2',
      startDate: DateTime.now().subtract(const Duration(days: 10)),
      endDate: DateTime.now().subtract(const Duration(days: 8)),
      reason: 'Family emergency',
      status: LeaveStatus.approved,
    ),
    LeaveRequest(
      id: '3',
      startDate: DateTime.now().subtract(const Duration(days: 15)),
      endDate: DateTime.now().subtract(const Duration(days: 15)),
      reason: 'Personal work',
      status: LeaveStatus.rejected,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'Leave Requests',
        profileName: 'John Doe',
        scaffoldKey: _scaffoldKey,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications not implemented')),
              );
            },
            tooltip: 'Notifications',
          ),
        ],
      ),
      drawer: const CustomDrawer(
        userName: 'John Doe',
        userEmail: 'john.doe@example.com',
      ),
      body: Column(
        children: [
          _buildTeacherInfoCard(context),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Leave Requests',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed:
                      () => showLeaveRequestDialog(context, (request) {
                        setState(() {
                          myRequests.add(request);
                        });
                      }),
                  icon: const Icon(Icons.add),
                  label: const Text('New Request'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child:
                myRequests.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.hourglass_empty,
                            size: 64,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No leave requests',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: myRequests.length,
                      itemBuilder: (context, index) {
                        return LeaveRequestCard(
                          request: myRequests[index],
                          onCancel:
                              myRequests[index].status == LeaveStatus.pending
                                  ? () {
                                    setState(() {
                                      myRequests.removeAt(index);
                                    });
                                  }
                                  : null,
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherInfoCard(BuildContext context) {
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
                  radius: 24,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  child: Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John Doe',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Mathematics Teacher',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                StatCard(title: 'Total Leaves', value: '12'),
                StatCard(title: 'Remaining', value: '7'),
                StatCard(title: 'Pending', value: '1'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
