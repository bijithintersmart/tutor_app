enum UserType { student, teacher, manager }

extension UserTypeExtension on UserType {
  String get value {
    switch (this) {
      case UserType.student:
        return 'Student';
      case UserType.teacher:
        return 'Teacher';
      case UserType.manager:
        return 'Manager';
    }
  }

  static UserType fromString(String role) {
    switch (role.toLowerCase()) {
      case 'student':
        return UserType.student;
      case 'teacher':
        return UserType.teacher;
      case 'manager':
        return UserType.manager;
      default:
        throw Exception('Unknown role: $role');
    }
  }
}
