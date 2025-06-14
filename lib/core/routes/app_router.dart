import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tutor_app/core/db/supabase_client.dart';
import 'package:tutor_app/core/utils/network_utils.dart';
import 'package:tutor_app/features/auth/presentation/pages/signup_screen.dart';
import 'package:tutor_app/features/network/presentation/cubit/network_cubit.dart';
import 'package:tutor_app/features/settings/presentation/pages/settings.dart';
import 'package:tutor_app/features/student/presentation/pages/student_home.dart';

import '../../features/features.dart';
import '../../features/manager/presentation/pages/manager_screen.dart';
import '../../features/teacher/presentation/pages/teacher_dashboard.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter._();
  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _service = GlobalNetworkService();

  static void initialize() {
    _service.initialize(router);
  }

  static NetworkCubit get networkCubit => _service.networkCubit;
  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.login,
    debugLogDiagnostics: true,
    redirect: _handleRedirect,
    refreshListenable: AuthNotifier(),
    routes: [
      // Authentication Routes
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => const SignupScreen(),
      ),

      // Manager Routes
      GoRoute(
        path: AppRoutes.manager,
        redirect: (context, state) {
          if (state.fullPath == AppRoutes.manager) {
            return AppRoutes.managerDashboard;
          }
          return null;
        },
        routes: [
          GoRoute(
            path: 'dashboard',
            name: 'manager-dashboard',
            builder: (context, state) => const ManagerDashboard(),
          ),
        ],
      ),

      // Teacher Routes
      GoRoute(
        path: AppRoutes.teacher,
        redirect: (context, state) {
          if (state.fullPath == AppRoutes.teacher) {
            return AppRoutes.teacherDashboard;
          }
          return null;
        },
        routes: [
          GoRoute(
            path: 'dashboard',
            name: 'teacher-dashboard',
            builder: (context, state) => const TeacherDashboard(),
          ),
        ],
      ),

      // Student Routes
      GoRoute(
        path: AppRoutes.student,
        redirect: (context, state) {
          if (state.fullPath == AppRoutes.student) {
            return AppRoutes.studentDashboard;
          }
          return null;
        },
        routes: [
          GoRoute(
            path: 'dashboard',
            name: 'student-dashboard',
            builder: (context, state) => const StudentHomeScreen(),
          ),
        ],
      ),

      // Splash Route
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
    errorBuilder: (context, state) => ErrorScreen(error: state.error),
  );

  static String? _handleRedirect(BuildContext context, GoRouterState state) {
    final isLoggedIn = Supabase.instance.client.auth.currentUser != null;
    final isLoggingIn = state.matchedLocation == AppRoutes.login;
    final isSplash = state.matchedLocation == AppRoutes.splash;
    final isRegister = state.matchedLocation == AppRoutes.register;

    if (!isLoggedIn && !isLoggingIn && !isSplash && !isRegister) {
      return AppRoutes.splash;
    }

    if (isLoggedIn && (isLoggingIn || isRegister)) {
      return getRedirectPathForUser();
    }

    if (!isLoggedIn && !isLoggingIn && !isSplash && !isRegister) {
      return AppRoutes.login;
    }

    return null;
  }

  static String getRedirectPathForUser() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return AppRoutes.login;

    final userRole = _getUserRoleFromMetadata(user);

    switch (userRole) {
      case UserType.manager:
        return AppRoutes.managerDashboard;
      case UserType.teacher:
        return AppRoutes.teacherDashboard;
      case UserType.student:
        return AppRoutes.studentDashboard;
    }
  }

  static UserType _getUserRoleFromMetadata(User user) {
    final roleString = user.userMetadata?['role'] as String?;
    if (roleString != null) {
      switch (roleString.toLowerCase()) {
        case 'manager':
          return UserType.manager;
        case 'teacher':
          return UserType.teacher;
        case 'student':
          return UserType.student;
      }
    }
    return UserType.student;
  }

  static void goToLogin() => _router.go(AppRoutes.login);
  static void goToManagerDashboard() => _router.go(AppRoutes.managerDashboard);
  static void goToTeacherDashboard() => _router.go(AppRoutes.teacherDashboard);
  static void goToStudentDashboard() => _router.go(AppRoutes.studentDashboard);
  static void goBack() => _router.pop();

  static Future<void> signOut() async {
    await SupabaseClientService().signOut();
    goToLogin();
  }
}

class AuthNotifier extends ChangeNotifier {
  AuthNotifier() {
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      notifyListeners();
    });
  }
}

extension AppRouterExtension on BuildContext {
  void goToLogin() => AppRouter.goToLogin();
  void goToManagerDashboard() => AppRouter.goToManagerDashboard();
  void goToTeacherDashboard() => AppRouter.goToTeacherDashboard();
  void goToStudentDashboard() => AppRouter.goToStudentDashboard();
  void goBack() => AppRouter.goBack();
  Future<void> signOut() => AppRouter.signOut();
}
