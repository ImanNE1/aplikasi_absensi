import 'package:shared_preferences/shared_preferences.dart';
import '/core/constants/app_constants.dart';
import '/data/models/user_model.dart'; // Jika menyimpan user model

abstract class ILocalDatasource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
  Future<void> saveUserRole(String role);
  Future<String?> getUserRole();
  Future<void> saveUserId(int userId);
  Future<int?> getUserId();
  Future<void> clearAll();
  // Tambahkan method lain untuk menyimpan data user, dll.
}

class LocalDatasource implements ILocalDatasource {
  final SharedPreferences _prefs;

  LocalDatasource(this._prefs);

  static Future<LocalDatasource> create() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalDatasource(prefs);
  }

  @override
  Future<void> saveToken(String token) async {
    await _prefs.setString(AppConstants.tokenKey, token);
  }

  @override
  Future<String?> getToken() async {
    return _prefs.getString(AppConstants.tokenKey);
  }

  @override
  Future<void> clearToken() async {
    await _prefs.remove(AppConstants.tokenKey);
  }

  @override
  Future<void> saveUserRole(String role) async {
    await _prefs.setString(AppConstants.userRoleKey, role);
  }

  @override
  Future<String?> getUserRole() async {
    return _prefs.getString(AppConstants.userRoleKey);
  }

  @override
  Future<void> saveUserId(int userId) async {
    await _prefs.setInt(AppConstants.userIdKey, userId);
  }

  @override
  Future<int?> getUserId() async {
    return _prefs.getInt(AppConstants.userIdKey);
  }

  @override
  Future<void> clearAll() async {
    await _prefs.remove(AppConstants.tokenKey);
    await _prefs.remove(AppConstants.userRoleKey);
    await _prefs.remove(AppConstants.userIdKey);
  }
}
