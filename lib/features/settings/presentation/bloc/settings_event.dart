part of 'settings_bloc.dart';

@freezed
class SettingsEvent with _$SettingsEvent {
  const factory SettingsEvent.loadSettings() = LoadSettings;

  const factory SettingsEvent.updatePushNotifications({required bool enabled}) =
      UpdatePushNotifications;

  const factory SettingsEvent.updateEmailNotifications({
    required bool enabled,
  }) = UpdateEmailNotifications;

  const factory SettingsEvent.updateTheme({required ThemeMode themeMode}) =
      UpdateTheme;

  const factory SettingsEvent.updateLanguage({required String language}) =
      UpdateLanguage;

  const factory SettingsEvent.updateBiometricAuth({required bool enabled}) =
      UpdateBiometricAuth;

  const factory SettingsEvent.updateAutoUpdate({required bool enabled}) =
      UpdateAutoUpdate;

  const factory SettingsEvent.resetSettings() = ResetSettings;
}
