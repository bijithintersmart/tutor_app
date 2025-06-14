import 'package:tutor_app/core/constants/storage_keys.dart';
import 'package:tutor_app/core/constants/strings.dart';
import 'package:get_storage/get_storage.dart';

class GlobalLocalStorage {
  static final GlobalLocalStorage _instance = GlobalLocalStorage._internal();
  late GetStorage _storage;

  factory GlobalLocalStorage() {
    return _instance;
  }

  GlobalLocalStorage._internal();

  Future<void> init({
    String storageBoxName = AppConstants.appName
  }) async {
    _storage = GetStorage();
  }

  Future<bool> setString(String key, String value) async {
    try {
      _storage.write(key, value);
      return true;
    } catch (e) {
      return false;
    }
  }

  String? getString(String key) {
    return _storage.read<String>(key);
  }

  Future<bool> removeString(String key) async {
    try {
      _storage.remove(key);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> setInt(String key, int value) async {
    try {
      _storage.write(key, value);
      return true;
    } catch (e) {
      return false;
    }
  }

  int? getInt(String key) {
    return _storage.read<int>(key);
  }

  Future<bool> setBool(String key, bool value) async {
    try {
      _storage.write(key, value);
      return true;
    } catch (e) {
      return false;
    }
  }

  bool? getBool(String key) {
    return _storage.read<bool>(key);
  }

  Future<bool> removeKey(String key) async {
    try {
      _storage.remove(key);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> clearData() async {
    try {
      _storage.remove(StorageKeys.AUTH_USER);
      _storage.remove(StorageKeys.AUTH_TOKEN);
      _storage.remove(StorageKeys.AUTH_ROLE);
      return true;
    } catch (e) {
      return false;
    }
  }
}
