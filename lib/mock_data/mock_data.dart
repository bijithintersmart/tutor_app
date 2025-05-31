import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tutor_app/features/student/data/models/booking_model.dart';
import 'package:tutor_app/features/student/data/models/student_model.dart';
import 'package:tutor_app/features/teacher/data/models/leave_request.dart';
import 'package:tutor_app/features/teacher/data/models/teacher_model.dart';
import 'package:tutor_app/features/teacher/data/models/time_slot.dart';

import '../features/manager/data/models/leave_request_model.dart';

class MockDataService {
  static final now = DateTime.now();
  static final List<Booking> _bookings = [
    Booking(
      id: '1',
      teacherId: '1',
      teacherName: 'Anjali Nair',
      studentId: '101',
      studentName: 'Rahul Sharma',
      date: now.subtract(const Duration(days: 1)),
      startTime: const TimeOfDay(hour: 9, minute: 0),
      durationMinutes: 60,
      subject: 'Mathematics',
    ),
    Booking(
      id: '2',
      teacherId: '2',
      teacherName: 'Arun Menon',
      studentId: '102',
      studentName: 'Priya Patel',
      date: now.add(const Duration(days: 3)),
      startTime: const TimeOfDay(hour: 11, minute: 0),
      durationMinutes: 60,
      subject: 'Chemistry',
    ),
    Booking(
      id: '3',
      teacherId: '3',
      teacherName: 'Divya Krishnan',
      studentId: '103',
      studentName: 'Arjun Kumar',
      date: now.add(const Duration(days: 5)),
      startTime: const TimeOfDay(hour: 14, minute: 0),
      durationMinutes: 120,
      subject: 'Malayalam',
    ),
  ];

  static List<Teacher> getTeachers() {
    final now = DateTime.now();
    dateFormat(DateTime date) =>
        "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

    // Generates dynamic availability for each teacher
    Map<String, List<TimeSlot>> generateAvailability(String teacherId) {
      return {
        for (int dayOffset = 0; dayOffset < 3; dayOffset++)
          dateFormat(now.add(Duration(days: dayOffset))): List.generate(
            3,
            (slotIndex) => TimeSlot(
              id: '$teacherId-${dayOffset * 3 + slotIndex + 1}',
              startTime: TimeOfDay(hour: 9 + slotIndex * 2, minute: 0),
              durationMinutes: 60,
            ),
          ),
      };
    }

    return [
      Teacher(
        id: '1',
        name: 'Anjali Nair',
        email: 'anjali.n@school.in',
        subjects: ['Mathematics', 'Physics'],
        availability: generateAvailability('1'),
        profilePicture: 'https://randomuser.me/api/portraits/men/67.jpg',
      ),
      Teacher(
        id: '2',
        name: 'Arun Menon',
        email: 'arun.m@school.in',
        subjects: ['Chemistry', 'Biology'],
        availability: generateAvailability('2'),
        profilePicture: 'https://randomuser.me/api/portraits/men/63.jpg',
      ),
      Teacher(
        id: '3',
        name: 'Divya Krishnan',
        email: 'divya.k@school.in',
        subjects: ['English', 'Malayalam', 'History'],
        availability: generateAvailability('3'),
        profilePicture: 'https://randomuser.me/api/portraits/men/62.jpg',
      ),
    ];
  }

  static List<Student> getStudents() {
    return [
      Student(
        id: '101',
        name: 'Rahul Sharma',
        email: 'rahul.s@school.in',
        subjects: ['Mathematics', 'Physics', 'Chemistry'],
        grade: '10th Grade',
        profilePicture: 'assets/images/rahul.jpg',
      ),
      Student(
        id: '102',
        name: 'Priya Patel',
        email: 'priya.p@school.in',
        subjects: ['Biology', 'Chemistry', 'Malayalam'],
        grade: '11th Grade',
        profilePicture: 'assets/images/priya.jpg',
      ),
      Student(
        id: '103',
        name: 'Arjun Kumar',
        email: 'arjun.k@school.in',
        subjects: ['English', 'Malayalam', 'History'],
        grade: '9th Grade',
        profilePicture: 'assets/images/arjun.jpg',
      ),
      Student(
        id: '104',
        name: 'Meera Nambiar',
        email: 'meera.n@school.in',
        subjects: ['Mathematics', 'Physics', 'English'],
        grade: '12th Grade',
        profilePicture: 'assets/images/meera.jpg',
      ),
      Student(
        id: '105',
        name: 'Vivek Thomas',
        email: 'vivek.t@school.in',
        subjects: ['Chemistry', 'Biology', 'History'],
        grade: '10th Grade',
        profilePicture: 'assets/images/vivek.jpg',
      ),
    ];
  }

  static List<Booking> getBookings() {
    return _bookings;
  }

  static void addBooking(Booking booking) {
    _bookings.add(booking);
  }

  static void removeBooking(String bookingId) {
    _bookings.removeWhere((booking) => booking.id == bookingId);
  }

  // Get bookings by student ID
  static List<Booking> getBookingsByStudent(String studentId) {
    return _bookings
        .where((booking) => booking.studentId == studentId)
        .toList();
  }

  // Get bookings by teacher ID
  static List<Booking> getBookingsByTeacher(String teacherId) {
    return _bookings
        .where((booking) => booking.teacherId == teacherId)
        .toList();
  }

  // Check if a teacher is available at a specific date and time
  static bool isTeacherAvailable(
    String teacherId,
    DateTime date,
    TimeOfDay time,
  ) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    String formattedTime =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

    // Check existing bookings
    bool hasConflictingBooking = _bookings.any(
      (booking) =>
          booking.teacherId == teacherId &&
          DateFormat('yyyy-MM-dd').format(booking.date) == formattedDate &&
          _timesOverlap(booking.startTime, booking.durationMinutes, time, 60),
    );

    if (hasConflictingBooking) {
      return false;
    }

    // Check teacher's availability
    Teacher? teacher = getTeachers().firstWhere(
      (t) => t.id == teacherId,
      orElse: () => throw Exception('Teacher not found'),
    );

    if (!teacher.availability.containsKey(formattedDate)) {
      return false;
    }

    return teacher.availability[formattedDate]!.contains(formattedTime);
  }

  // Helper method to check if two time slots overlap
  static bool _timesOverlap(
    TimeOfDay time1,
    int duration1,
    TimeOfDay time2,
    int duration2,
  ) {
    // Convert times to minutes since midnight
    int start1 = time1.hour * 60 + time1.minute;
    int end1 = start1 + duration1;

    int start2 = time2.hour * 60 + time2.minute;
    int end2 = start2 + duration2;

    // Check for overlap
    return start1 < end2 && start2 < end1;
  }

  static List<LeaveRequest> getLeaveRequests() {
    return [
      LeaveRequest(
        id: '1',
        startDate: DateTime.now().add(const Duration(days: 5)),
        endDate: DateTime.now().add(const Duration(days: 7)),
        reason: 'Family vacation',
        status: LeaveStatus.pending,
      ),
      LeaveRequest(
        id: '2',
        startDate: DateTime.now().add(const Duration(days: 15)),
        endDate: DateTime.now().add(const Duration(days: 17)),
        reason: 'Medical appointment',
        status: LeaveStatus.approved,
        comment: 'Approved by principal',
      ),
      LeaveRequest(
        id: '3',
        startDate: DateTime.now().subtract(const Duration(days: 10)),
        endDate: DateTime.now().subtract(const Duration(days: 8)),
        reason: 'Professional development workshop',
        status: LeaveStatus.approved,
      ),
      LeaveRequest(
        id: '4',
        startDate: DateTime.now().subtract(const Duration(days: 30)),
        endDate: DateTime.now().subtract(const Duration(days: 30)),
        reason: 'Personal leave',
        status: LeaveStatus.rejected,
        comment: 'Too many teachers already on leave that day',
      ),
    ];
  }
  static List<ManagerLeaveRequest> getManagerLeaveRequests() {
    return [
      ManagerLeaveRequest(
        id: '1',
        teacherName: 'John Doe',
        fromDate: DateTime.now().add(const Duration(days: 1)),
        toDate: DateTime.now().add(const Duration(days: 2)),
        reason: 'Medical appointment',
        status: 'Pending',
      ),
      ManagerLeaveRequest(
        id: '2',
        teacherName: 'John Doe',
        fromDate: DateTime.now().subtract(const Duration(days: 10)),
        toDate: DateTime.now().subtract(const Duration(days: 8)),
        reason: 'Family emergency',
        status: 'Approved',
      ),
      ManagerLeaveRequest(
        id: '3',
        teacherName: 'Jane Smith',
        fromDate: DateTime.now(),
        toDate: DateTime.now().add(const Duration(days: 5)),
        reason: 'Family function',
        status: 'Pending',
      ),
      ManagerLeaveRequest(
        id: '4',
        teacherName: 'Mark Johnson',
        fromDate: DateTime.now().subtract(const Duration(days: 5)),
        toDate: DateTime.now().subtract(const Duration(days: 3)),
        reason: 'Personal work',
        status: 'Approved',
      ),
      ManagerLeaveRequest(
        id: '5',
        teacherName: 'Sarah Williams',
        fromDate: DateTime.now().add(const Duration(days: 3)),
        toDate: DateTime.now().add(const Duration(days: 4)),
        reason: 'Vacation',
        status: 'Pending',
      ),
    ];
  }
}
