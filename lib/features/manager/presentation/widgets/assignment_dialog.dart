import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tutor_app/features/student/data/models/booking_model.dart';
import 'package:tutor_app/features/student/data/models/student_model.dart';
import 'package:tutor_app/features/teacher/data/models/teacher_model.dart';
import 'package:tutor_app/features/teacher/data/models/time_slot.dart';
import 'package:tutor_app/mock_data/mock_data.dart';

class AssignmentDialog extends StatefulWidget {
  final Teacher teacher;
  final DateTime selectedDate;
  final List<String> subjectFilters;
  final Function(Booking) onSave;

  const AssignmentDialog({
    super.key,
    required this.teacher,
    required this.selectedDate,
    required this.subjectFilters,
    required this.onSave,
  });

  @override
  State<AssignmentDialog> createState() => _AssignmentDialogState();
}

class _AssignmentDialogState extends State<AssignmentDialog>
    with SingleTickerProviderStateMixin {
  Student? _selectedStudent;
  TimeOfDay? _selectedTime;
  int _duration = 60;
  String? _selectedSubject;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  final List<Student> _students = MockDataService.getStudents();

  @override
  void initState() {
    super.initState();
    _selectedSubject =
        widget.subjectFilters.isNotEmpty
            ? widget.subjectFilters.first
            : widget.teacher.subjects.first;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(widget.selectedDate);
    List<TimeSlot> availableSlots =
        widget.teacher.availability[formattedDate] ?? [];

    return ScaleTransition(
      scale: _scaleAnimation,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Assign Student to ${widget.teacher.name}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Student:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              DropdownButtonFormField<Student>(
                isExpanded: true,
                value: _selectedStudent,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
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
              const SizedBox(height: 16),
              Text(
                'Date: ${DateFormat('MMM dd, yyyy').format(widget.selectedDate)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              if (widget.teacher.subjects.length > 1) ...[
                Text(
                  'Select Subject:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                DropdownButtonFormField<String>(
                  value: _selectedSubject,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items:
                      widget.teacher.subjects.map((String subject) {
                        return DropdownMenuItem<String>(
                          value: subject,
                          child: Text(subject),
                        );
                      }).toList(),
                  onChanged: (String? value) {
                    if (value != null) {
                      setState(() {
                        _selectedSubject = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
              ],
              Text(
                'Available Time Slots:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (availableSlots.isEmpty)
                Text(
                  'No available slots for this date',
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              else
                DropdownButtonFormField<TimeSlot>(
                  hint: const Text('Select a time slot'),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items:
                      availableSlots.map((TimeSlot slot) {
                        return DropdownMenuItem<TimeSlot>(
                          value: slot,
                          child: Text(
                            "${slot.formattedStartTime} - ${slot.formattedEndTime}",
                          ),
                        );
                      }).toList(),
                  onChanged: (TimeSlot? value) {
                    if (value != null) {
                      setState(() {
                        _selectedTime = TimeOfDay(
                          hour: int.parse(
                            value.formattedStartTime.split(':')[0],
                          ),
                          minute: int.parse(
                            value.formattedStartTime
                                .split(':')[1]
                                .split(' ')[0],
                          ),
                        );
                      });
                    }
                  },
                ),
              const SizedBox(height: 16),
              Text('Duration:', style: Theme.of(context).textTheme.titleMedium),
              Slider(
                value: _duration.toDouble(),
                min: 30,
                max: 120,
                divisions: 3,
                label: '$_duration mins',
                onChanged: (double value) {
                  setState(() {
                    _duration = value.round();
                  });
                },
              ),
              Text('$_duration minutes'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed:
                _selectedStudent != null && _selectedTime != null
                    ? () {
                      Navigator.pop(context);
                      final booking = Booking(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        teacherId: widget.teacher.id,
                        teacherName: widget.teacher.name,
                        studentId: _selectedStudent!.id,
                        studentName: _selectedStudent!.name,
                        subject: _selectedSubject!,
                        date: widget.selectedDate,
                        startTime: _selectedTime!,
                        durationMinutes: _duration,
                      );
                      widget.onSave(booking);
                    }
                    : null,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Confirm Assignment'),
          ),
        ],
      ),
    );
  }
}
