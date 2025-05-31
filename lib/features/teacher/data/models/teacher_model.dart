import 'time_slot.dart';

class Teacher {
  final String id;
  final String name;
  final String email;
  final List<String> subjects;
  final Map<String, List<TimeSlot>> availability;
  final String? profilePicture;

  Teacher({
    required this.id,
    required this.name,
    required this.email,
    required this.subjects,
    required this.availability,
    this.profilePicture,
  });
}
