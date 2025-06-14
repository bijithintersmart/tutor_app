import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stack_trace/stack_trace.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tutor_app/core/db/supabase_client.dart';
import 'package:tutor_app/core/routes/app_router.dart';
import 'package:tutor_app/core/theme/app_theme.dart';
import 'package:tutor_app/core/utils/app_error_handler.dart';
import 'package:tutor_app/core/utils/functions.dart';

import 'package:tutor_app/features/auth/data/models/user.dart';

Future<void> main() async {
  final errorHandler = AppErrorHandler();
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await initializeAppConfig();
      errorHandler.initialize();
      runApp(const TutorApp());
    },
    (error, stackTrace) {
      Chain.capture(() {
        errorHandler.handleError(
          error,
          stackTrace,
          errorType: getExceptionType(error),
        );
      });
    },
  );
}

class TutorApp extends StatefulWidget {
  const TutorApp({super.key});

  @override
  State<TutorApp> createState() => _TutorAppState();
}

class _TutorAppState extends State<TutorApp> {
  @override
  void initState() {
    AppRouter.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: AppRouter.networkCubit,
      child: MaterialApp.router(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
        builder: (context, child) {
          return child ?? const SizedBox();
        },
      ),
    );
  }
}

abstract class AuthAwareWidget extends StatefulWidget {
  const AuthAwareWidget({super.key});
}

abstract class AuthAwareState<T extends AuthAwareWidget> extends State<T> {
  late final SupabaseClientService _supabaseService;

  @override
  void initState() {
    super.initState();
    _supabaseService = SupabaseClientService();

    // Listen to auth state changes
    _supabaseService.authStateChanges.listen((authState) {
      if (mounted) {
        onAuthStateChanged(authState);
      }
    });
  }

  void onAuthStateChanged(AuthState authState) {
    if (authState.event == AuthChangeEvent.signedOut) {
      context.goToLogin();
    }
  }

  SupabaseClientService get supabaseService => _supabaseService;

  bool get isAuthenticated => _supabaseService.isAuthenticated;

  UserType get currentUserType => _supabaseService.currentUserType;
}

class BaseDashboardWidget extends AuthAwareWidget {
  final Widget child;
  final String title;

  const BaseDashboardWidget({
    super.key,
    required this.child,
    required this.title,
  });

  @override
  State<BaseDashboardWidget> createState() => _BaseDashboardWidgetState();
}

class _BaseDashboardWidgetState extends AuthAwareState<BaseDashboardWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              switch (value) {
                case 'profile':
                  // Navigate to profile
                  break;
                case 'settings':
                  // Navigate to settings
                  break;
                case 'logout':
                  await context.signOut();
                  break;
              }
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'profile',
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Profile'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'settings',
                    child: ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Settings'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: 'logout',
                    child: ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Logout'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
          ),
        ],
      ),
      body: widget.child,
    );
  }

  @override
  void onAuthStateChanged(AuthState authState) {
    super.onAuthStateChanged(authState);

    // Additional dashboard-specific auth handling
    if (authState.event == AuthChangeEvent.signedIn) {
      // Refresh dashboard data
      setState(() {});
    }
  }
}
