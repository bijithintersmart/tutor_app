import 'package:flutter/material.dart';
import 'package:tutor_app/core/common_widget/custom_appbar.dart';
import 'package:tutor_app/core/common_widget/custom_drawer.dart';
import 'package:tutor_app/features/manager/data/models/leave_request_model.dart';
import 'package:tutor_app/features/manager/presentation/widgets/leave_filter.dart';
import 'package:tutor_app/features/manager/presentation/widgets/leave_list.dart';
import 'package:tutor_app/mock_data/mock_data.dart';

class ManagerLeavesDashboard extends StatefulWidget {
  const ManagerLeavesDashboard({super.key});

  @override
  State<ManagerLeavesDashboard> createState() => _ManagerLeavesDashboardState();
}

class _ManagerLeavesDashboardState extends State<ManagerLeavesDashboard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;
  String? _selectedTeacher;
  DateTime? _startDate;
  DateTime? _endDate;
  List<ManagerLeaveRequest> _allRequests = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _allRequests = MockDataService.getManagerLeaveRequests();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<ManagerLeaveRequest> _getFilteredRequests(String status) {
    return _allRequests.where((request) {
      if (_selectedTeacher != null && request.teacherName != _selectedTeacher) {
        return false;
      }
      if (_startDate != null && request.fromDate.isBefore(_startDate!)) {
        return false;
      }
      if (_endDate != null && request.toDate.isAfter(_endDate!)) {
        return false;
      }
      return request.status == status;
    }).toList();
  }

  List<String> _getTeacherNames() {
    return _allRequests.map((r) => r.teacherName).toSet().toList()..sort();
  }

  void _approveRequest(String id) {
    setState(() {
      final request = _allRequests.firstWhere((r) => r.id == id);
      request.status = 'Approved';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Leave request approved'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _rejectRequest(String id) {
    setState(() {
      _allRequests.removeWhere((r) => r.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Leave request rejected'),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendingRequests = _getFilteredRequests('Pending');
    final approvedRequests = _getFilteredRequests('Approved');

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'Leave Requests',
        profileName: 'David Wilson',
        scaffoldKey: _scaffoldKey,
      ),
      drawer: const CustomDrawer(
        userName: 'David Wilson',
        userEmail: 'david.w@school.edu',
      ),
      body: Column(
        children: [
          LeaveFilter(
            teacherNames: _getTeacherNames(),
            selectedTeacher: _selectedTeacher,
            startDate: _startDate,
            endDate: _endDate,
            onTeacherChanged:
                (teacher) => setState(() => _selectedTeacher = teacher),
            onStartDateChanged: (date) => setState(() => _startDate = date),
            onEndDateChanged: (date) => setState(() => _endDate = date),
            onClearFilters:
                () => setState(() {
                  _selectedTeacher = null;
                  _startDate = null;
                  _endDate = null;
                }),
          ),
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Pending'),
                    const SizedBox(width: 8),
                    if (pendingRequests.isNotEmpty)
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Text(
                          '${pendingRequests.length}',
                          style: Theme.of(
                            context,
                          ).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Approved'),
                    const SizedBox(width: 8),
                    if (approvedRequests.isNotEmpty)
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Text(
                          '${approvedRequests.length}',
                          style: Theme.of(
                            context,
                          ).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
            labelStyle: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            unselectedLabelColor:
                Theme.of(context).colorScheme.onSurfaceVariant,
            labelColor: Theme.of(context).colorScheme.primary,
            indicatorColor: Theme.of(context).colorScheme.primary,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                LeaveList(
                  requests: pendingRequests,
                  showActions: true,
                  onApprove: _approveRequest,
                  onReject: _rejectRequest,
                ),
                LeaveList(requests: approvedRequests),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
