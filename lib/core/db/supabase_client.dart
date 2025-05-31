import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tutor_app/features/auth/data/models/user.dart';

class SupabaseClientService {
  static final SupabaseClientService _instance =
      SupabaseClientService._internal();
  factory SupabaseClientService() => _instance;
  SupabaseClientService._internal();

  SupabaseClient get client => Supabase.instance.client;

  bool get isAuthenticated => client.auth.currentUser != null;

  User? get currentUser => client.auth.currentUser;

  UserRole get currentUserRole {
    final user = currentUser;
    if (user == null) return UserRole.student;

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

    return UserRole.student;
  }

  Future<AuthResponse> signIn(String email, String password) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Login failed: No user returned');
      }

      return response;
    } on AuthException catch (e) {
      throw Exception('Login failed: ${e.message}');
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required UserRole role,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final metadata = {'role': role.label, ...?additionalData};

      final response = await client.auth.signUp(
        email: email,
        password: password,
        data: metadata,
      );

      if (response.user == null) {
        throw Exception('Sign up failed: No user returned');
      }

      return response;
    } on AuthException catch (e) {
      throw Exception('Sign up failed: ${e.message}');
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await client.auth.signOut();
    } on AuthException catch (e) {
      throw Exception('Sign out failed: ${e.message}');
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await client.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw Exception('Password reset failed: ${e.message}');
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  Future<UserResponse> updateUserMetadata({Map<String, dynamic>? data}) async {
    try {
      final response = await client.auth.updateUser(UserAttributes(data: data));

      if (response.user == null) {
        throw Exception('Update failed: No user returned');
      }

      return response;
    } on AuthException catch (e) {
      throw Exception('Update failed: ${e.message}');
    } catch (e) {
      throw Exception('Update failed: $e');
    }
  }

  Future<UserResponse> updateUserRole(UserRole newRole) async {
    return updateUserMetadata(data: {'role': newRole.label});
  }

  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;

  bool hasRole(UserRole role) {
    return currentUserRole == role;
  }

  bool get isManager => hasRole(UserRole.manager);

  bool get isTeacher => hasRole(UserRole.teacher);

  bool get isStudent => hasRole(UserRole.student);

  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final user = currentUser;
      if (user == null) return null;

      final response =
          await client.from('profiles').select().eq('id', user.id).single();

      return response;
    } catch (e) {
      return null;
    }
  }

  Future<void> upsertUserProfile(Map<String, dynamic> profileData) async {
    try {
      final user = currentUser;
      if (user == null) throw Exception('No authenticated user');

      await client.from('profiles').upsert({
        'id': user.id,
        'email': user.email,
        'role': currentUserRole.label,
        'updated_at': DateTime.now().toIso8601String(),
        ...profileData,
      });
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  static Future<void> initialize({
    required String url,
    required String anonKey,
  }) async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    );
  }
}

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.manager:
        return 'Manager';
      case UserRole.teacher:
        return 'Teacher';
      case UserRole.student:
        return 'Student';
    }
  }

  String get dashboardRoute {
    switch (this) {
      case UserRole.manager:
        return '/manager/dashboard';
      case UserRole.teacher:
        return '/teacher/dashboard';
      case UserRole.student:
        return '/student/dashboard';
    }
  }
}
