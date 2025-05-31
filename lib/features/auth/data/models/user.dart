enum UserRole { student, teacher, manager }

extension UserRoleExtension on UserRole {
  String get label {
    switch (this) {
      case UserRole.student:
        return 'Student';
      case UserRole.teacher:
        return 'Teacher';
      case UserRole.manager:
        return 'Manager';
    }
  }

  static UserRole fromString(String role) {
    switch (role.toLowerCase()) {
      case 'student':
        return UserRole.student;
      case 'teacher':
        return UserRole.teacher;
      case 'manager':
        return UserRole.manager;
      default:
        throw Exception('Unknown role: $role');
    }
  }
}
