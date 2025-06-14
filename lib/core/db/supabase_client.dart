import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tutor_app/core/routes/app_router.dart';
import 'package:tutor_app/core/utils/app_logger.dart';
import 'package:tutor_app/core/utils/app_messenger.dart';
import 'package:tutor_app/features/auth/data/models/user.dart';

class SupabaseClientService {
  static final SupabaseClientService _instance =
      SupabaseClientService._internal();
  factory SupabaseClientService() => _instance;
  SupabaseClientService._internal();

  SupabaseClient get client => Supabase.instance.client;

  bool get isAuthenticated => client.auth.currentUser != null;

  User? get currentUser => client.auth.currentUser;

  UserType get currentUserType {
    final user = currentUser;
    if (user == null) return UserType.student;

    final roleString = user.userMetadata?['role'] as String?;
    switch (roleString?.toLowerCase()) {
      case 'manager':
        return UserType.manager;
      case 'teacher':
        return UserType.teacher;
      case 'student':
        return UserType.student;
      default:
        return UserType.student;
    }
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
      AppLogger.logInfo("User: ${response.user?.toJson()}");
      AppLogger.logInfo("Session: ${response.session?.toJson()}");
      return response;
    } on AuthException catch (e) {
      _handleError('Login failed', e.message);
      throw Exception(e.message);
    } catch (e) {
      _handleError('Login failed', e.toString());
      throw Exception(e.toString());
    }
  }

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String displayName,
    required String phone,
    required UserType role,
  }) async {
    try {
      final metadata = {
        'role': role.value,
        'display_name': displayName,
        'phone': phone,
      };

      final response = await client.auth.signUp(
        email: email,
        password: password,
        data: metadata,
      );

      final user = response.user;
      if (user == null) {
        throw Exception('Sign up failed: No user returned');
      }

      final initials = _getInitialsFromEmail(email);
      await upsertUserProfile({
        'email': email,
        'phone': phone,
        'display_name': displayName,
        'profile_image': _generateLetterProfileImage(initials),
      });

      return response;
    } on AuthException catch (e) {
      _handleError('Sign up failed', e.message);
      throw Exception(e.message);
    } catch (e) {
      _handleError('Sign up failed', e.toString());
      throw Exception(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await client.auth.signOut();
    } on AuthException catch (e) {
      _handleError('Sign out failed', e.message);
      throw Exception(e.message);
    } catch (e) {
      _handleError('Sign out failed', e.toString());
      throw Exception(e.toString());
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await client.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      _handleError('Password reset failed', e.message);
      throw Exception(e.message);
    } catch (e) {
      _handleError('Password reset failed', e.toString());
      throw Exception(e.toString());
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
      _handleError('Update failed', e.message);
      throw Exception(e.message);
    } catch (e) {
      _handleError('Update failed', e.toString());
      throw Exception(e.toString());
    }
  }

  Future<UserResponse> updateUserType(UserType newRole) async {
    return updateUserMetadata(data: {'role': newRole.value});
  }

  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;

  bool hasRole(UserType role) => currentUserType == role;

  bool get isManager => hasRole(UserType.manager);
  bool get isTeacher => hasRole(UserType.teacher);
  bool get isStudent => hasRole(UserType.student);

  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final user = currentUser;
      if (user == null) return null;

      return await client.from('profiles').select().eq('id', user.id).single();
    } catch (_) {
      return null;
    }
  }

  Future<void> upsertUserProfile(Map<String, dynamic> profileData) async {
    try {
      final user = currentUser;
      if (user == null) {
        throw Exception('No authenticated user');
      }

      await client.from('profiles').upsert({
        'id': user.id,
        'role': currentUserType.label,
        'updated_at': DateTime.now().toIso8601String(),
        ...profileData,
      });
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  String _generateLetterProfileImage(String initials) {
    return 'https://ui-avatars.com/api/?name=$initials&background=0D8ABC&color=fff&size=256';
  }

  String _getInitialsFromEmail(String email) {
    final namePart = email.split('@').first;
    return namePart.isNotEmpty ? namePart[0].toUpperCase() : 'U';
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

  void _handleError(String title, String message) {
    log('$title: $message');
    AppMessenger.scaffoldMessenger(
      message: message,
      bgColor: Colors.black,
      context: AppRouter.rootNavigatorKey.currentContext!,
    );
  }
}

extension UserTypeExtension on UserType {
  String get label {
    switch (this) {
      case UserType.manager:
        return 'Manager';
      case UserType.teacher:
        return 'Teacher';
      case UserType.student:
        return 'Student';
    }
  }

  String get dashboardRoute {
    switch (this) {
      case UserType.manager:
        return '/manager/dashboard';
      case UserType.teacher:
        return '/teacher/dashboard';
      case UserType.student:
        return '/student/dashboard';
    }
  }
}
