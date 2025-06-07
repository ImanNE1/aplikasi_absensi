import '/data/models/user_model.dart';
// import 'package:aplikasi_absensi/data/services/api_service.dart'; 
import '/data/datasources/remote_datasource.dart'; // BARU
import '/data/datasources/local_datasource.dart'; // BARU
// import 'package:dio/dio.dart'; 

// Interface untuk AuthRepository 
abstract class IAuthRepository {
  Future<(User?, String?)> login(String identifier, String password);
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<String?> getRole(); 
}

class AuthRepository implements IAuthRepository {
  final IRemoteDatasource _remoteDatasource;
  final ILocalDatasource _localDatasource;

  AuthRepository(this._remoteDatasource, this._localDatasource);

  @override
  Future<(User?, String?)> login(String identifier, String password) async {
    try {
      final response = await _remoteDatasource.post('auth/login', data: {
        'identifier': identifier,
        'password': password,
      });

      // Asumsi API mengembalikan status 200 untuk sukses
      // dan body JSON seperti: { "token": "...", "user": { ... } }
      if (response.statusCode == 200 && response.data != null) {
        final responseData = response.data as Map<String, dynamic>;
        final user =
            User.fromJson(responseData['user'] as Map<String, dynamic>);
        final token = responseData['token'] as String;

        await _localDatasource.saveToken(token);
        await _localDatasource.saveUserRole(user.group);
        await _localDatasource.saveUserId(user.id);

        return (user, token);
      } else {
        throw response.data?['message'] ??
            'Login gagal. Periksa kembali NIP/Email dan Password Anda.';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<void> logout() async {
    try {
      // Panggil API logout jika ada endpointnya
      // await _remoteDatasource.post('auth/logout');
    } catch (e) {
      // Abaikan error saat logout dari API, yang penting data lokal dihapus
      print("Error calling API logout: $e");
    }
    await _localDatasource.clearAll();
  }

  @override
  Future<User?> getCurrentUser() async {
    // hanya role dan token. Jika API punya endpoint /me atau /user, panggil itu.
    String? token = await _localDatasource.getToken();
    if (token == null) return null;

    try {
      // Ganti 'auth/me' dengan endpoint API Anda untuk mendapatkan data user saat ini
      final response = await _remoteDatasource.get('auth/me');
      if (response.statusCode == 200 && response.data != null) {
        final responseData = response.data as Map<String, dynamic>;
        // Cek apakah ada key 'user' atau langsung data user
        if (responseData.containsKey('user') && responseData['user'] != null) {
          return User.fromJson(responseData['user'] as Map<String, dynamic>);
        } else if (responseData.containsKey('id') &&
            responseData.containsKey('name')) {
          // Jika API langsung mengembalikan data user tanpa dibungkus 'user'
          return User.fromJson(responseData);
        }
      }
      return null;
    } catch (e) {
      print('Error getCurrentUser from API: $e');
      // Jika gagal ambil dari API (misal token expired), bisa coba logout
      // await logout(); // Hati-hati infinite loop jika ini dipanggil dari _checkInitialAuthStatus
      return null;
    }
  }

  @override
  Future<String?> getRole() async {
    return await _localDatasource.getUserRole();
  }
}
