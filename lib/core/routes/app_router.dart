import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tutor_app/core/db/supabase_client.dart';
import 'package:tutor_app/features/auth/presentation/pages/signup_screen.dart';
import 'package:tutor_app/features/student/presentation/pages/student_home.dart';

import '../../features/features.dart';
import '../../features/manager/presentation/pages/manager_screen.dart';
import '../../features/teacher/presentation/pages/teacher_dashboard.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    debugLogDiagnostics: true,
    redirect: _handleRedirect,
    refreshListenable: AuthNotifier(),
    routes: [
      // Authentication Routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const SignupScreen(),
      ),

      // Manager Routes
      GoRoute(
        path: '/manager',
        redirect: (context, state) {
          // Redirect to manager dashboard if just accessing /manager
          if (state.fullPath == '/manager') {
            return '/manager/dashboard';
          }
          return null;
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            name: 'manager-dashboard',
            builder: (context, state) => const ManagerDashboard(),
          ),
          // GoRoute(
          //   path: '/teacher-profile',
          //   name: 'manager-teacher-profile',
          //   builder: (context, state) => const TeacherProfileScreen(),
          // ),
          // GoRoute(
          //   path: '/bookings',
          //   name: 'manager-bookings',
          //   builder: (context, state) => const ManagerBookingsScreen(),
          // ),
        ],
      ),

      // Teacher Routes
      GoRoute(
        path: '/teacher',
        redirect: (context, state) {
          // Redirect to teacher dashboard if just accessing /teacher
          if (state.fullPath == '/teacher') {
            return '/teacher/dashboard';
          }
          return null;
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            name: 'teacher-dashboard',
            builder: (context, state) => const TeacherDashboard(),
          ),
        ],
      ),

      // Student Routes
      GoRoute(
        path: '/student',
        redirect: (context, state) {
          // Redirect to student dashboard if just accessing /student
          if (state.fullPath == '/student') {
            return '/student/dashboard';
          }
          return null;
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            name: 'student-dashboard',
            builder: (context, state) => const StudentHomeScreen(),
          ),
        ],
      ),

      // Splash/Loading Screen Route
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
    ],

    // Error handling
    errorBuilder: (context, state) => ErrorScreen(error: state.error),
  );

  /// Handles authentication-based redirects
  static String? _handleRedirect(BuildContext context, GoRouterState state) {
    final isLoggedIn = Supabase.instance.client.auth.currentUser != null;
    final isLoggingIn = state.matchedLocation == '/login';
    final isSplash = state.matchedLocation == '/splash';
    final isRegister = state.matchedLocation == '/register';

    // Show splash screen while checking authentication
    if (!isLoggedIn && !isLoggingIn && !isSplash && !isRegister) {
      return '/splash';
    }

    // If logged in and trying to access login or register, redirect to appropriate dashboard
    if (isLoggedIn && (isLoggingIn || isRegister)) {
      return getRedirectPathForUser();
    }

    // If not logged in and trying to access protected routes, redirect to login
    if (!isLoggedIn && !isLoggingIn && !isSplash && !isRegister) {
      return '/login';
    }

    return null; // No redirect needed
  }

  /// Gets the appropriate redirect path based on user role
  static String getRedirectPathForUser() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return '/login';

    // Get user role from metadata or database
    final userRole = _getUserRoleFromMetadata(user);

    switch (userRole) {
      case UserRole.manager:
        return '/manager/dashboard';
      case UserRole.teacher:
        return '/teacher/dashboard';
      case UserRole.student:
        return '/student/dashboard';
      }
  }

  /// Extracts user role from Supabase user metadata
  static UserRole _getUserRoleFromMetadata(User user) {
    final roleString = user.userMetadata?['role'] as String?;

    if (roleString != null) {
      switch (roleString.toLowerCase()) {
        case 'manager':
          return UserRole.manager;
        case 'teacher':
          return UserRole.teacher;
        case 'student':
          return UserRole.student;
      }
    }

    // Default fallback - you might want to fetch from database here
    return UserRole.student;
  }

  /// Navigation helper methods
  static void goToLogin() {
    _router.go('/login');
  }

  static void goToManagerDashboard() {
    _router.go('/manager/dashboard');
  }

  static void goToTeacherDashboard() {
    _router.go('/teacher/dashboard');
  }

  static void goToStudentDashboard() {
    _router.go('/student/dashboard');
  }

  static void goBack() {
    _router.pop();
  }

  /// Sign out and redirect to login
  static Future<void> signOut() async {
    await SupabaseClientService().signOut();
    goToLogin();
  }
}

/// Auth notifier to listen to authentication state changes
class AuthNotifier extends ChangeNotifier {
  AuthNotifier() {
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      notifyListeners();
    });
  }
}

/// Extension for easier navigation in widgets
extension AppRouterExtension on BuildContext {
  void goToLogin() => AppRouter.goToLogin();
  void goToManagerDashboard() => AppRouter.goToManagerDashboard();
  void goToTeacherDashboard() => AppRouter.goToTeacherDashboard();
  void goToStudentDashboard() => AppRouter.goToStudentDashboard();
  void goBack() => AppRouter.goBack();
  Future<void> signOut() => AppRouter.signOut();
}
