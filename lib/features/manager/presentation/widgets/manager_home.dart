import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tutor_app/core/common_widget/custom_appbar.dart';
import 'package:tutor_app/core/common_widget/custom_drawer.dart';
import 'package:tutor_app/features/manager/presentation/widgets/assignment_dialog.dart';
import 'package:tutor_app/features/manager/presentation/widgets/teacher_filter.dart';
import 'package:tutor_app/features/manager/presentation/widgets/teacher_list.dart';
import 'package:tutor_app/features/student/data/models/booking_model.dart';
import 'package:tutor_app/features/teacher/data/models/teacher_model.dart';
import 'package:tutor_app/mock_data/mock_data.dart';

class ManagerHome extends StatefulWidget {
  const ManagerHome({super.key});

  @override
  State<ManagerHome> createState() => _ManagerHomeState();
}

class _ManagerHomeState extends State<ManagerHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime _selectedDate = DateTime.now();
  List<String> _subjectFilters = [];
  List<Teacher> _teachers = [];

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
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Manager Dashboard',
        profileName: 'David Wilson',
        scaffoldKey: _scaffoldKey,
      ),
      drawer: const CustomDrawer(
        userName: 'David Wilson',
        userEmail: 'david.w@school.edu',
      ),
      body: Column(
        children: [
          TeacherFilter(
            selectedDate: _selectedDate,
            subjectFilters: _subjectFilters,
            allSubjects: _getAllSubjects(),
            onDateChanged: (date) => setState(() => _selectedDate = date),
            onSubjectFiltersChanged:
                (filters) => setState(() => _subjectFilters = filters),
          ),
          Expanded(
            child: TeacherList(
              teachers: _getFilteredTeachers(),
              selectedDate: _selectedDate,
              onClearFilters:
                  () => setState(() {
                    _subjectFilters.clear();
                    _selectedDate = DateTime.now();
                  }),
              onAssignPressed: (teacher) {
                showDialog(
                  context: context,
                  builder:
                      (context) => AssignmentDialog(
                        teacher: teacher,
                        selectedDate: _selectedDate,
                        subjectFilters: _subjectFilters,
                        onSave: _saveBooking,
                      ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
