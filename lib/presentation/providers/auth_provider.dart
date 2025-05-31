import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/data/models/user_model.dart';
import '/data/repositories/auth_repository.dart';
import '/data/datasources/remote_datasource.dart'; // BARU
import '/data/datasources/local_datasource.dart'; // BARU

enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
  loading
} // BARU: loading state

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  AuthState({required this.status, this.user, this.errorMessage});

  AuthState copyWith(
      {AuthStatus? status,
      User? user,
      String? errorMessage,
      bool clearError = false}) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final IAuthRepository _authRepository;

  AuthNotifier(this._authRepository)
      : super(AuthState(status: AuthStatus.unknown)) {
    _checkInitialAuthStatus();
  }

  Future<void> _checkInitialAuthStatus() async {
    // Cek apakah ada token tersimpan
    final role =
        await _authRepository.getRole(); // Mengambil role dari local storage

    if (role != null) {
      // Jika ada role, coba ambil data user dari API (validasi token)
      final currentUser = await _authRepository.getCurrentUser();
      if (currentUser != null) {
        state = AuthState(status: AuthStatus.authenticated, user: currentUser);
      } else {
        // Token mungkin tidak valid lagi, atau getCurrentUser gagal
        await _authRepository.logout(); // Hapus sisa data lokal
        state = AuthState(
            status: AuthStatus.unauthenticated,
            errorMessage: "Sesi berakhir, silakan login kembali.");
      }
    } else {
      state = AuthState(status: AuthStatus.unauthenticated);
    }
  }

  Future<bool> login(String identifier, String password) async {
    // BARU: return bool
    try {
      state = state.copyWith(status: AuthStatus.loading, clearError: true);
      final (user, token) = await _authRepository.login(identifier, password);
      if (user != null && token != null) {
        state = AuthState(status: AuthStatus.authenticated, user: user);
        return true; // BARU
      } else {
        // Seharusnya tidak sampai sini jika repository melempar error
        state = AuthState(
            status: AuthStatus.unauthenticated,
            errorMessage: 'Login Gagal. Data tidak ditemukan.');
        return false; // BARU
      }
    } catch (e) {
      state = AuthState(
          status: AuthStatus.unauthenticated, errorMessage: e.toString());
      return false; // BARU
    }
  }

  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading); // BARU
    await _authRepository.logout();
    state = AuthState(
        status: AuthStatus.unauthenticated,
        user: null); // Pastikan user juga null
  }
}

// --- Providers ---
// BARU: Provider untuk LocalDatasource
final localDatasourceProvider = FutureProvider<ILocalDatasource>((ref) async {
  return await LocalDatasource.create();
});

final remoteDatasourceProvider =
    Provider<IRemoteDatasource>((ref) => RemoteDatasource());

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final remoteDs = ref.watch(remoteDatasourceProvider);
  // Menggunakan watch untuk localDatasourceProvider karena ini FutureProvider
  final localDsAsyncValue = ref.watch(localDatasourceProvider);

  // Handle async value dari localDatasourceProvider
  // Ini adalah cara sederhana, untuk produksi mungkin perlu error handling lebih baik
  // atau memastikan provider ini sudah ready sebelum authRepositoryProvider diakses.
  // Salah satu cara adalah membuat AuthRepository juga async atau menunda inisialisasi AuthNotifier.
  // Untuk contoh ini, kita akan throw error jika localDs belum siap,
  // atau Anda bisa return sebuah implementasi "NullAuthRepository" jika belum siap.
  if (localDsAsyncValue is AsyncData<ILocalDatasource>) {
    return AuthRepository(remoteDs, localDsAsyncValue.value);
  }
  // Jika masih loading atau error, idealnya jangan sampai AuthNotifier dibuat.
  // Atau, AuthNotifier bisa handle IAuthRepository yang null/belum siap.
  // Untuk sementara, kita throw exception jika belum siap.
  // Ini akan menyebabkan error jika AuthNotifier di-create sebelum localDatasourceProvider ready.
  // Solusi yang lebih baik: buat AuthNotifier menunggu localDatasourceProvider.
  throw Exception("LocalDatasource not yet available for AuthRepository");
});

// MODIFIKASI: AuthNotifierProvider sekarang menunggu AuthRepository siap
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  // Menggunakan watch untuk authRepositoryProvider.
  // Jika authRepositoryProvider melempar error (karena localDatasource belum siap),
  // maka provider ini juga akan error.
  // Ini perlu di-handle di UI (misalnya dengan AsyncValueWidget).
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthNotifier(authRepository);
});
