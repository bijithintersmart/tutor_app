// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SettingsStateImpl _$$SettingsStateImplFromJson(Map<String, dynamic> json) =>
    _$SettingsStateImpl(
      pushNotifications: json['pushNotifications'] as bool? ?? true,
      emailNotifications: json['emailNotifications'] as bool? ?? false,
      themeMode:
          json['themeMode'] == null
              ? ThemeMode.system
              : const ThemeModeConverter().fromJson(
                json['themeMode'] as String,
              ),
      language: json['language'] as String? ?? 'English',
      biometricAuth: json['biometricAuth'] as bool? ?? true,
      autoUpdate: json['autoUpdate'] as bool? ?? true,
      isLoading: json['isLoading'] as bool? ?? false,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$$SettingsStateImplToJson(_$SettingsStateImpl instance) =>
    <String, dynamic>{
      'pushNotifications': instance.pushNotifications,
      'emailNotifications': instance.emailNotifications,
      'themeMode': const ThemeModeConverter().toJson(instance.themeMode),
      'language': instance.language,
      'biometricAuth': instance.biometricAuth,
      'autoUpdate': instance.autoUpdate,
      'isLoading': instance.isLoading,
      'error': instance.error,
    };
