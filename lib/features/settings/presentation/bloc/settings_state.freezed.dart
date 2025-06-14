// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SettingsState _$SettingsStateFromJson(Map<String, dynamic> json) {
  return _SettingsState.fromJson(json);
}

/// @nodoc
mixin _$SettingsState {
  bool get pushNotifications => throw _privateConstructorUsedError;
  bool get emailNotifications => throw _privateConstructorUsedError;
  @ThemeModeConverter()
  ThemeMode get themeMode => throw _privateConstructorUsedError;
  String get language => throw _privateConstructorUsedError;
  bool get biometricAuth => throw _privateConstructorUsedError;
  bool get autoUpdate => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Serializes this SettingsState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SettingsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SettingsStateCopyWith<SettingsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingsStateCopyWith<$Res> {
  factory $SettingsStateCopyWith(
    SettingsState value,
    $Res Function(SettingsState) then,
  ) = _$SettingsStateCopyWithImpl<$Res, SettingsState>;
  @useResult
  $Res call({
    bool pushNotifications,
    bool emailNotifications,
    @ThemeModeConverter() ThemeMode themeMode,
    String language,
    bool biometricAuth,
    bool autoUpdate,
    bool isLoading,
    String? error,
  });
}

/// @nodoc
class _$SettingsStateCopyWithImpl<$Res, $Val extends SettingsState>
    implements $SettingsStateCopyWith<$Res> {
  _$SettingsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SettingsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pushNotifications = null,
    Object? emailNotifications = null,
    Object? themeMode = null,
    Object? language = null,
    Object? biometricAuth = null,
    Object? autoUpdate = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(
      _value.copyWith(
            pushNotifications:
                null == pushNotifications
                    ? _value.pushNotifications
                    : pushNotifications // ignore: cast_nullable_to_non_nullable
                        as bool,
            emailNotifications:
                null == emailNotifications
                    ? _value.emailNotifications
                    : emailNotifications // ignore: cast_nullable_to_non_nullable
                        as bool,
            themeMode:
                null == themeMode
                    ? _value.themeMode
                    : themeMode // ignore: cast_nullable_to_non_nullable
                        as ThemeMode,
            language:
                null == language
                    ? _value.language
                    : language // ignore: cast_nullable_to_non_nullable
                        as String,
            biometricAuth:
                null == biometricAuth
                    ? _value.biometricAuth
                    : biometricAuth // ignore: cast_nullable_to_non_nullable
                        as bool,
            autoUpdate:
                null == autoUpdate
                    ? _value.autoUpdate
                    : autoUpdate // ignore: cast_nullable_to_non_nullable
                        as bool,
            isLoading:
                null == isLoading
                    ? _value.isLoading
                    : isLoading // ignore: cast_nullable_to_non_nullable
                        as bool,
            error:
                freezed == error
                    ? _value.error
                    : error // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SettingsStateImplCopyWith<$Res>
    implements $SettingsStateCopyWith<$Res> {
  factory _$$SettingsStateImplCopyWith(
    _$SettingsStateImpl value,
    $Res Function(_$SettingsStateImpl) then,
  ) = __$$SettingsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool pushNotifications,
    bool emailNotifications,
    @ThemeModeConverter() ThemeMode themeMode,
    String language,
    bool biometricAuth,
    bool autoUpdate,
    bool isLoading,
    String? error,
  });
}

/// @nodoc
class __$$SettingsStateImplCopyWithImpl<$Res>
    extends _$SettingsStateCopyWithImpl<$Res, _$SettingsStateImpl>
    implements _$$SettingsStateImplCopyWith<$Res> {
  __$$SettingsStateImplCopyWithImpl(
    _$SettingsStateImpl _value,
    $Res Function(_$SettingsStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SettingsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pushNotifications = null,
    Object? emailNotifications = null,
    Object? themeMode = null,
    Object? language = null,
    Object? biometricAuth = null,
    Object? autoUpdate = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(
      _$SettingsStateImpl(
        pushNotifications:
            null == pushNotifications
                ? _value.pushNotifications
                : pushNotifications // ignore: cast_nullable_to_non_nullable
                    as bool,
        emailNotifications:
            null == emailNotifications
                ? _value.emailNotifications
                : emailNotifications // ignore: cast_nullable_to_non_nullable
                    as bool,
        themeMode:
            null == themeMode
                ? _value.themeMode
                : themeMode // ignore: cast_nullable_to_non_nullable
                    as ThemeMode,
        language:
            null == language
                ? _value.language
                : language // ignore: cast_nullable_to_non_nullable
                    as String,
        biometricAuth:
            null == biometricAuth
                ? _value.biometricAuth
                : biometricAuth // ignore: cast_nullable_to_non_nullable
                    as bool,
        autoUpdate:
            null == autoUpdate
                ? _value.autoUpdate
                : autoUpdate // ignore: cast_nullable_to_non_nullable
                    as bool,
        isLoading:
            null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                    as bool,
        error:
            freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SettingsStateImpl implements _SettingsState {
  const _$SettingsStateImpl({
    this.pushNotifications = true,
    this.emailNotifications = false,
    @ThemeModeConverter() this.themeMode = ThemeMode.system,
    this.language = 'English',
    this.biometricAuth = true,
    this.autoUpdate = true,
    this.isLoading = false,
    this.error,
  });

  factory _$SettingsStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$SettingsStateImplFromJson(json);

  @override
  @JsonKey()
  final bool pushNotifications;
  @override
  @JsonKey()
  final bool emailNotifications;
  @override
  @JsonKey()
  @ThemeModeConverter()
  final ThemeMode themeMode;
  @override
  @JsonKey()
  final String language;
  @override
  @JsonKey()
  final bool biometricAuth;
  @override
  @JsonKey()
  final bool autoUpdate;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;

  @override
  String toString() {
    return 'SettingsState(pushNotifications: $pushNotifications, emailNotifications: $emailNotifications, themeMode: $themeMode, language: $language, biometricAuth: $biometricAuth, autoUpdate: $autoUpdate, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettingsStateImpl &&
            (identical(other.pushNotifications, pushNotifications) ||
                other.pushNotifications == pushNotifications) &&
            (identical(other.emailNotifications, emailNotifications) ||
                other.emailNotifications == emailNotifications) &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.biometricAuth, biometricAuth) ||
                other.biometricAuth == biometricAuth) &&
            (identical(other.autoUpdate, autoUpdate) ||
                other.autoUpdate == autoUpdate) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    pushNotifications,
    emailNotifications,
    themeMode,
    language,
    biometricAuth,
    autoUpdate,
    isLoading,
    error,
  );

  /// Create a copy of SettingsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SettingsStateImplCopyWith<_$SettingsStateImpl> get copyWith =>
      __$$SettingsStateImplCopyWithImpl<_$SettingsStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SettingsStateImplToJson(this);
  }
}

abstract class _SettingsState implements SettingsState {
  const factory _SettingsState({
    final bool pushNotifications,
    final bool emailNotifications,
    @ThemeModeConverter() final ThemeMode themeMode,
    final String language,
    final bool biometricAuth,
    final bool autoUpdate,
    final bool isLoading,
    final String? error,
  }) = _$SettingsStateImpl;

  factory _SettingsState.fromJson(Map<String, dynamic> json) =
      _$SettingsStateImpl.fromJson;

  @override
  bool get pushNotifications;
  @override
  bool get emailNotifications;
  @override
  @ThemeModeConverter()
  ThemeMode get themeMode;
  @override
  String get language;
  @override
  bool get biometricAuth;
  @override
  bool get autoUpdate;
  @override
  bool get isLoading;
  @override
  String? get error;

  /// Create a copy of SettingsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SettingsStateImplCopyWith<_$SettingsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
