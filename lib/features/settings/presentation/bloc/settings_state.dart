import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tutor_app/features/settings/presentation/bloc/theme_conveter.dart';
part 'settings_state.freezed.dart';
part 'settings_state.g.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(true) bool pushNotifications,
    @Default(false) bool emailNotifications,
    @Default(ThemeMode.system) @ThemeModeConverter() ThemeMode themeMode,
    @Default('English') String language,
    @Default(true) bool biometricAuth,
    @Default(true) bool autoUpdate,
    @Default(false) bool isLoading,
    String? error,
  }) = _SettingsState;

  factory SettingsState.fromJson(Map<String, dynamic> json) =>
      _$SettingsStateFromJson(json);
}
