import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Booking {
  final String id;
  final String teacherId;
  final String teacherName;
  final String studentId;
  final String studentName;
  final DateTime date;
  final TimeOfDay startTime;
  final int durationMinutes;
  final String subject;

  Booking({
    required this.id,
    required this.teacherId,
    required this.teacherName,
    required this.studentId,
    required this.studentName,
    required this.date,
    required this.startTime,
    required this.durationMinutes,
    required this.subject,
  });

  String get formattedDate {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  String get formattedTime {
    final endHour =
        (startTime.hour + (startTime.minute + durationMinutes) ~/ 60) % 24;
    final endMinute = (startTime.minute + durationMinutes) % 60;

    final startHour = startTime.hour.toString().padLeft(2, '0');
    final startMinute = startTime.minute.toString().padLeft(2, '0');

    final endHourStr = endHour.toString().padLeft(2, '0');
    final endMinuteStr = endMinute.toString().padLeft(2, '0');

    return '$startHour:$startMinute - $endHourStr:$endMinuteStr';
  }
}
