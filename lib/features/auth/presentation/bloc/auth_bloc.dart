import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/models/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SupabaseClient supabase;

  AuthBloc(this.supabase) : super(const AuthState.initial()) {
    on<_Login>(_onLogin);
    on<_Logout>(_onLogout);
  }

  Future<void> _onLogin(_Login event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());

    try {
      final response = await supabase.auth.signInWithPassword(
        email: event.email,
        password: event.password,
      );

      final userId = response.user?.id;
      if (userId == null) {
        emit(const AuthState.unauthenticated('User ID not found'));
        return;
      }

      final result =
          await supabase
              .from('users')
              .select('role')
              .eq('id', userId)
              .maybeSingle();

      if (result == null || result['role'] == null) {
        emit(const AuthState.unauthenticated('Role not found'));
        return;
      }

      final role = UserRoleExtension.fromString(result['role']);
      emit(AuthState.authenticated(role));
    } catch (e) {
      emit(AuthState.unauthenticated(e.toString()));
    }
  }

  Future<void> _onLogout(_Logout event, Emitter<AuthState> emit) async {
    await supabase.auth.signOut();
    emit(const AuthState.unauthenticated(null));
  }
}
