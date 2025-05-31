import 'package:flutter/material.dart';
import 'package:tutor_app/features/student/data/models/booking_model.dart';
import 'package:tutor_app/features/teacher/data/models/leave_request.dart';
import 'package:tutor_app/features/teacher/data/models/teacher_model.dart';
import 'package:tutor_app/features/teacher/presentation/pages/teacher_leave_request.dart';
import 'package:tutor_app/features/teacher/presentation/pages/teacher_profile.dart';
import 'package:tutor_app/features/teacher/presentation/widgets/dashboard_home.dart';
import 'package:tutor_app/features/teacher/presentation/widgets/schedule_screen.dart';
import 'package:tutor_app/features/teacher/presentation/widgets/availability_screen.dart';
import 'package:tutor_app/mock_data/mock_data.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  int _selectedIndex = 0;
  List<Booking> _bookings = [];
  List<LeaveRequest> _leaveRequests = [];

  @override
  void initState() {
    super.initState();
    _bookings = MockDataService.getBookings();
    _leaveRequests = MockDataService.getLeaveRequests();
  }

  List<Booking> get _upcomingBookings {
    final now = DateTime.now();
    return _bookings
        .where(
          (booking) =>
              booking.date.isAfter(now) ||
              (booking.date.day == now.day &&
                  booking.date.month == now.month &&
                  booking.date.year == now.year &&
                  booking.startTime.hour >= TimeOfDay.now().hour),
        )
        .toList();
  }

  List<Booking> get _previousBookings {
    final now = DateTime.now();
    return _bookings
        .where(
          (booking) =>
              booking.date.isBefore(now) &&
              !(booking.date.day == now.day &&
                  booking.date.month == now.month &&
                  booking.date.year == now.year &&
                  booking.startTime.hour >= TimeOfDay.now().hour),
        )
        .toList();
  }

  List<LeaveRequest> get _pendingLeaveRequests {
    return _leaveRequests
        .where((request) => request.status == LeaveStatus.pending)
        .toList();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      DashboardHome(
        bookings: _bookings,
        pendingLeaveRequests: _pendingLeaveRequests,
        onNavigateToTab: _onItemTapped,
      ),
      ScheduleScreen(
        upcomingBookings: _upcomingBookings,
        previousBookings: _previousBookings,
      ),
      const AvailabilityScreen(),
      // LeaveRequestScreen(
      //   pendingLeaveRequests: _pendingLeaveRequests,
      //   pastLeaveRequests: _pastLeaveRequests,
      //   onLeaveRequestAdded: (request) {
      //     setState(() {
      //       _leaveRequests.add(request);
      //     });
      //   },
      // ),
      TeacherLeaveRequest(),
      TeacherProfileScreen(
        selectedDate: DateTime.now(),
        teacher: Teacher(
          id: "12",
          name: "John Smith",
          email: 'john@gmail.com',
          subjects: ['English,Malayalam'],
          availability: {},
        ),
      ),
    ];

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: screens[_selectedIndex],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today),
            label: 'Schedule',
          ),
          NavigationDestination(
            icon: Icon(Icons.access_time_outlined),
            selectedIcon: Icon(Icons.access_time),
            label: 'Availability',
          ),
          NavigationDestination(
            icon: Icon(Icons.timer_outlined),
            selectedIcon: Icon(Icons.timer),
            label: 'Leave',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outlined),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
