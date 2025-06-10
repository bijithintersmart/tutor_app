import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tutor_app/core/contants/strings.dart';
import 'package:tutor_app/core/db/supabase_client.dart';
import 'package:tutor_app/core/routes/app_router.dart';
import 'package:tutor_app/features/auth/data/models/user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
   await SupabaseClientService.initialize(
    url: dotenv.get("DB_URL", fallback: ""),
    anonKey: dotenv.get("ANON_KEY", fallback: ""),
  );
  runApp(const TutorApp());
}

class TutorApp extends StatelessWidget {
  const TutorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(elevation: 0, centerTitle: true),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(elevation: 0, centerTitle: true),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
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

  UserRole get currentUserRole => _supabaseService.currentUserRole;
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
