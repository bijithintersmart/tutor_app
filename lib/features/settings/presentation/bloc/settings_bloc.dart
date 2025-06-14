import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'settings_state.dart';

part 'settings_event.dart';
part 'settings_bloc.freezed.dart';


class SettingsBloc extends HydratedBloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsState()) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdatePushNotifications>(_onUpdatePushNotifications);
    on<UpdateEmailNotifications>(_onUpdateEmailNotifications);
    on<UpdateTheme>(_onUpdateTheme);
    on<UpdateLanguage>(_onUpdateLanguage);
    on<UpdateBiometricAuth>(_onUpdateBiometricAuth);
    on<UpdateAutoUpdate>(_onUpdateAutoUpdate);
    on<ResetSettings>(_onResetSettings);
  }

  void _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) {
    emit(state.copyWith(isLoading: false));
  }

  void _onUpdatePushNotifications(
    UpdatePushNotifications event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(pushNotifications: event.enabled));
  }

  void _onUpdateEmailNotifications(
    UpdateEmailNotifications event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(emailNotifications: event.enabled));
  }

  void _onUpdateTheme(UpdateTheme event, Emitter<SettingsState> emit) {
    emit(state.copyWith(themeMode: event.themeMode));
  }

  void _onUpdateLanguage(UpdateLanguage event, Emitter<SettingsState> emit) {
    emit(state.copyWith(language: event.language));
  }

  void _onUpdateBiometricAuth(
    UpdateBiometricAuth event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(biometricAuth: event.enabled));
  }

  void _onUpdateAutoUpdate(
    UpdateAutoUpdate event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(autoUpdate: event.enabled));
  }

  void _onResetSettings(ResetSettings event, Emitter<SettingsState> emit) {
    emit(const SettingsState());
  }

  @override
  SettingsState? fromJson(Map<String, dynamic> json) {
    try {
      return SettingsState.fromJson(json);
    } catch (e) {
      // Return null to use initial state if deserialization fails
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(SettingsState state) {
    try {
      return state.toJson();
    } catch (e) {
      // Return null to skip serialization if it fails
      return null;
    }
  }
}
