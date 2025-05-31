import 'package:flutter/material.dart';
import 'package:tutor_app/core/common_widget/custom_appbar.dart';
import 'package:tutor_app/core/common_widget/custom_drawer.dart';
import 'package:tutor_app/features/manager/presentation/widgets/assignment_dialog.dart';
import 'package:tutor_app/features/teacher/data/models/teacher_model.dart';
import 'package:tutor_app/features/teacher/presentation/widgets/availability_card.dart';
import 'package:tutor_app/features/teacher/presentation/widgets/booking_list.dart';
import 'package:tutor_app/features/teacher/presentation/widgets/teacher_profile_card.dart';
import 'package:tutor_app/mock_data/mock_data.dart';

class TeacherProfileScreen extends StatefulWidget {
  final Teacher teacher;
  final DateTime selectedDate;

  const TeacherProfileScreen({
    super.key,
    required this.teacher,
    required this.selectedDate,
  });

  @override
  State<TeacherProfileScreen> createState() => _TeacherProfileScreenState();
}

class _TeacherProfileScreenState extends State<TeacherProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final bookings =
        MockDataService.getBookings()
            .where(
              (b) =>
                  b.teacherId == widget.teacher.id &&
                  b.date.isAfter(
                    DateTime.now().subtract(const Duration(days: 1)),
                  ),
            )
            .toList();

    return Scaffold(key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'Profile',
        profileName: 'David Wilson',
        scaffoldKey: _scaffoldKey,
      ),
      drawer: const CustomDrawer(
        userName: 'David Wilson',
        userEmail: 'david.w@school.edu',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TeacherProfileCard(teacher: widget.teacher),
            AvailabilityCard(
              teacher: widget.teacher,
              selectedDate: widget.selectedDate,
            ),
            BookingList(bookings: bookings),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.assignment),
                label: const Text('Assign Student'),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (context) => AssignmentDialog(
                          teacher: widget.teacher,
                          selectedDate: widget.selectedDate,
                          subjectFilters: [],
                          onSave: (booking) {
                            MockDataService.addBooking(booking);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Assigned ${booking.studentName} to ${booking.teacherName}',
                                ),
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          },
                        ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
