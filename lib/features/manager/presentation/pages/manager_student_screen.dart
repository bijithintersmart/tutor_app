import 'package:flutter/material.dart';
import 'package:tutor_app/core/common_widget/custom_appbar.dart';
import 'package:tutor_app/core/common_widget/custom_drawer.dart';
import 'package:tutor_app/features/manager/presentation/widgets/student_list.dart';
import 'package:tutor_app/features/student/data/models/student_model.dart';
import 'package:tutor_app/mock_data/mock_data.dart';

class ManagerStudentsDashboard extends StatefulWidget {
  const ManagerStudentsDashboard({super.key});

  @override
  State<ManagerStudentsDashboard> createState() =>
      _ManagerStudentsDashboardState();
}

class _ManagerStudentsDashboardState extends State<ManagerStudentsDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Student> _students = [];

  @override
  void initState() {
    super.initState();
    _students = MockDataService.getStudents();
  }

  void _editStudent(Student student) {
    // Placeholder for edit dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit student ${student.name} not implemented'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _deleteStudent(Student student) {
    setState(() {
      _students.removeWhere((s) => s.id == student.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Student ${student.name} deleted'),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'Manage Students',
        profileName: 'David Wilson',
        scaffoldKey: _scaffoldKey,
      ),
      drawer: const CustomDrawer(
        userName: 'David Wilson',
        userEmail: 'david.w@school.edu',
      ),
      body: StudentList(
        students: _students,
        onEdit: _editStudent,
        onDelete: _deleteStudent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Placeholder for add student dialog
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
              content: Text('Add student not implemented'),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
