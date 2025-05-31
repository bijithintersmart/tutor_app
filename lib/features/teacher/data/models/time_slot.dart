import 'package:flutter/material.dart';

class TimeSlot {
  final String id;
  final TimeOfDay startTime;
  final int durationMinutes;
  final bool isBooked;

  TimeSlot({
    required this.id,
    required this.startTime,
    required this.durationMinutes,
    this.isBooked = false,
  });

  String get formattedStartTime {
    final hour = startTime.hour.toString().padLeft(2, '0');
    final minute = startTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String get formattedEndTime {
    final endHour =
        (startTime.hour + (startTime.minute + durationMinutes) ~/ 60) % 24;
    final endMinute = (startTime.minute + durationMinutes) % 60;
    final hour = endHour.toString().padLeft(2, '0');
    final minute = endMinute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
