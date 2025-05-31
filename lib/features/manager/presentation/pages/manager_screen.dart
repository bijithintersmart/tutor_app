import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tutor_app/core/db/supabase_client.dart';
import 'package:tutor_app/features/manager/presentation/pages/manager_leave_request_screen.dart';
import 'package:tutor_app/features/manager/presentation/widgets/booking_screen.dart';
import 'package:tutor_app/features/manager/presentation/widgets/manager_home.dart';
import 'package:tutor_app/features/manager/presentation/widgets/profile_section.dart';
import 'package:tutor_app/features/manager/presentation/widgets/student_assignment.dart';
import 'package:tutor_app/features/student/data/models/booking_model.dart';
import 'package:tutor_app/features/teacher/data/models/teacher_model.dart';
import 'package:tutor_app/mock_data/mock_data.dart';

class ManagerDashboard extends StatefulWidget {
  const ManagerDashboard({super.key});

  @override
  State<ManagerDashboard> createState() => _ManagerDashboardState();
}

class _ManagerDashboardState extends State<ManagerDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  List<Teacher> _teachers = [];
  List<String> _subjectFilters = [];
  DateTime _selectedDate = DateTime.now();
  final supabaseClient = SupabaseClientService();

  @override
  void initState() {
    super.initState();
    _teachers = MockDataService.getTeachers();
  }

  List<String> _getAllSubjects() {
    Set<String> subjects = {};
    for (var teacher in _teachers) {
      subjects.addAll(teacher.subjects);
    }
    return subjects.toList()..sort();
  }

  List<Teacher> _getFilteredTeachers() {
    return _teachers.where((teacher) {
      if (_subjectFilters.isNotEmpty) {
        bool hasMatchingSubject = false;
        for (var subject in _subjectFilters) {
          if (teacher.subjects.contains(subject)) {
            hasMatchingSubject = true;
            break;
          }
        }
        if (!hasMatchingSubject) return false;
      }
      String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
      if (!teacher.availability.containsKey(formattedDate) ||
          teacher.availability[formattedDate]!.isEmpty) {
        return false;
      }
      return true;
    }).toList();
  }

  void _saveBooking(Booking booking) {
    MockDataService.addBooking(booking);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Successfully assigned ${booking.studentName} to ${booking.teacherName} on ${DateFormat('MMM dd').format(booking.date)} at ${booking.formattedTime}',
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
     ManagerHome(),
      BookingScreen(),
      StudentAssignment(
        allSubjects: _getAllSubjects(),
        filteredTeachers: _getFilteredTeachers(),
        selectedDate: _selectedDate,
        subjectFilters: _subjectFilters,
        onDateChanged: (date) => setState(() => _selectedDate = date),
        onSubjectFiltersChanged:
            (filters) => setState(() => _subjectFilters = filters),
        onSaveBooking: _saveBooking,
      ),
      const ManagerLeavesDashboard(),
      ProfileSection(
        onEditProfile: () {
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
              content: Text('Edit profile not implemented'),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
      ),
    ];

    return Scaffold(
      key: _scaffoldKey,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return screens[_selectedIndex];
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Teachers'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Assignments',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Leaves'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

}
