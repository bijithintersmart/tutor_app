import 'package:flutter/material.dart';
import 'package:tutor_app/core/common_widget/custom_appbar.dart';
import 'package:tutor_app/core/common_widget/custom_drawer.dart';
import 'package:tutor_app/features/student/data/models/session.dart';
import 'package:tutor_app/features/student/presentation/widgets/complete_session.dart';
import 'package:tutor_app/features/student/presentation/widgets/session_card.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(
        title: 'My Sessions',
        profileName: 'David Wilson',
        scaffoldKey: scaffoldKey,
        bottom: TabBar(
                  controller: _tabController,
                  indicatorColor: Theme.of(context).colorScheme.primary,
                  indicatorWeight: 3,
                  indicatorSize: TabBarIndicatorSize.label,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color:
                                _selectedIndex == 0
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(
                                      context,
                                    ).textTheme.bodySmall!.color,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Upcoming',
                            style: TextStyle(
                              color:
                                  _selectedIndex == 0
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(
                                        context,
                                      ).textTheme.bodySmall!.color,
                              fontWeight:
                                  _selectedIndex == 0
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history,
                            color:
                                _selectedIndex == 1
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(
                                      context,
                                    ).textTheme.bodySmall!.color,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Past',
                            style: TextStyle(
                              color:
                                  _selectedIndex == 1
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(
                                        context,
                                      ).textTheme.bodySmall!.color,
                              fontWeight:
                                  _selectedIndex == 1
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
      ),
      drawer: const CustomDrawer(
        userName: 'David Wilson',
        userEmail: 'david.w@school.edu',
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildUpcomingSessions(), _buildPastSessions()],
      ),
    );
  }

  Widget _buildUpcomingSessions() {
    return upcomingSessions.isEmpty
        ? Center(
          child: Text(
            'No upcoming sessions',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        )
        : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: upcomingSessions.length,
          itemBuilder: (context, index) {
            final session = upcomingSessions[index];
            return SessionCard(session: session);
          },
        );
  }

  Widget _buildPastSessions() {
    return pastSessions.isEmpty
        ? Center(
          child: Text(
            'No past sessions',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        )
        : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: pastSessions.length,
          itemBuilder: (context, index) {
            final session = pastSessions[index];
            return CompleteSessionWidget(session: session);
          },
        );
  }
}
