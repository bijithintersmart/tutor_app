import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tutor_app/core/common_widget/custom_appbar.dart';
import 'package:tutor_app/core/common_widget/custom_drawer.dart';
import 'package:tutor_app/features/manager/presentation/widgets/assignment_dialog.dart';
import 'package:tutor_app/features/student/data/models/booking_model.dart';
import 'package:tutor_app/features/student/data/models/student_model.dart';
import 'package:tutor_app/features/teacher/data/models/teacher_model.dart';
import 'package:tutor_app/mock_data/mock_data.dart';

class StudentAssignment extends StatefulWidget {
  const StudentAssignment({
    super.key,
    required this.allSubjects,
    required this.filteredTeachers,
    required this.selectedDate,
    required this.subjectFilters,
    required this.onDateChanged,
    required this.onSubjectFiltersChanged,
    required this.onSaveBooking,
  });

  final List<String> allSubjects;
  final List<Teacher> filteredTeachers;
  final ValueChanged<DateTime> onDateChanged;
  final Function(Booking) onSaveBooking;
  final ValueChanged<List<String>> onSubjectFiltersChanged;
  final DateTime selectedDate;
  final List<String> subjectFilters;

  @override
  State<StudentAssignment> createState() => _StudentAssignmentState();
}

class _StudentAssignmentState extends State<StudentAssignment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Student? _selectedStudent;
  final List<Student> _students = MockDataService.getStudents();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Student Assignment',
        profileName: 'David Wilson',
        scaffoldKey: _scaffoldKey,
      ),
      drawer: const CustomDrawer(
        userName: 'David Wilson',
        userEmail: 'david.w@school.edu',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Assign Students to Teachers',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Step 1: Select Student',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<Student>(
                      decoration: InputDecoration(
                        labelText: 'Select Student',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      value: _selectedStudent,
                      items:
                          _students.map((Student student) {
                            return DropdownMenuItem<Student>(
                              value: student,
                              child: Text(student.name),
                            );
                          }).toList(),
                      onChanged: (Student? value) {
                        setState(() {
                          _selectedStudent = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Step 2: Select Date',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                DateFormat(
                                  'MMM dd, yyyy',
                                ).format(widget.selectedDate),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: widget.selectedDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(
                                const Duration(days: 60),
                              ),
                            );
                            if (picked != null) {
                              widget.onDateChanged(picked);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Change Date'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Step 3: Select Subject',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          widget.allSubjects.map((subject) {
                            final isSelected = widget.subjectFilters.contains(
                              subject,
                            );
                            return FilterChip(
                              label: Text(subject),
                              selected: isSelected,
                              onSelected: (selected) {
                                final newFilters = List<String>.from(
                                  widget.subjectFilters,
                                );
                                if (selected) {
                                  newFilters.clear();
                                  newFilters.add(subject);
                                } else {
                                  newFilters.remove(subject);
                                }
                                widget.onSubjectFiltersChanged(newFilters);
                              },
                              backgroundColor:
                                  Theme.of(context).colorScheme.surfaceContainer,
                              selectedColor:
                                  Theme.of(context).colorScheme.primaryContainer,
                            );
                          }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Step 4: Available Teachers',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child:
                          widget.filteredTeachers.isEmpty
                              ? Center(
                                child: Text(
                                  'No teachers available with these filters',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              )
                              : ListView.builder(
                                itemCount: widget.filteredTeachers.length,
                                itemBuilder: (context, index) {
                                  final teacher = widget.filteredTeachers[index];
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      child: Text(
                                        teacher.name.substring(0, 1),
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge?.copyWith(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.onPrimary,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      teacher.name,
                                      style:
                                          Theme.of(context).textTheme.titleMedium,
                                    ),
                                    subtitle: Text(
                                      teacher.subjects.join(', '),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.copyWith(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                    trailing: ElevatedButton(
                                      onPressed:
                                          _selectedStudent == null
                                              ? null
                                              : () => showDialog(
                                                context: context,
                                                builder:
                                                    (context) => AssignmentDialog(
                                                      teacher: teacher,
                                                      selectedDate:
                                                          widget.selectedDate,
                                                      subjectFilters:
                                                          widget.subjectFilters,
                                                      onSave:
                                                          widget.onSaveBooking,
                                                    ),
                                              ),
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: const Text('Assign'),
                                    ),
                                  );
                                },
                              ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
