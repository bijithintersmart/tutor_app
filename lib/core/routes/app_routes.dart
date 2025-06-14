class AppRoutes {
  AppRoutes._();

  static const login = '/login';
  static const register = '/register';

  // Splash
  static const splash = '/splash';

  // Manager routes
  static const manager = '/manager';
  static const managerDashboard = '/manager/dashboard';
  // static const managerTeacherProfile = '/manager/teacher-profile';
  // static const managerBookings = '/manager/bookings';

  // Teacher routes
  static const teacher = '/teacher';
  static const teacherDashboard = '/teacher/dashboard';

  // Student routes
  static const student = '/student';
  static const studentDashboard = '/student/dashboard';

  //utils
  static const networkError = '/networkError';
  static const apiTimeOut = '/apiTimeout';
  static const settings = '/settings';

}
