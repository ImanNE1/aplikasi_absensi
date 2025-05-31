import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '/presentation/providers/auth_provider.dart';
import '/routes/app_router.dart'; // BARU

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // _checkAuthAndNavigate(); // Logika navigasi sekarang ditangani oleh GoRouter redirect
    // Cukup pastikan AuthNotifier._checkInitialAuthStatus() terpanggil
    // yang mana sudah dilakukan di konstruktor AuthNotifier.
    // GoRouter akan menunggu status auth menjadi selain unknown/loading.
    Future.delayed(const Duration(milliseconds: 500), () {
      // Memberi sedikit waktu untuk auth provider melakukan pengecekan awal.
      // GoRouter redirect akan menangani sisanya.
      // Jika authState masih unknown, redirect akan menjaga di splash.
      // Jika sudah authenticated/unauthenticated, redirect akan mengarahkan.
      // Ini hanya untuk memastikan ada sedikit delay di splash screen.
      // Sebenarnya, logic navigasi utama ada di GoRouter.redirect
      final authState = ref.read(authNotifierProvider);
      print(
          "Splash screen initState, current auth status: ${authState.status}");
      if (mounted &&
          (authState.status != AuthStatus.unknown &&
              authState.status != AuthStatus.loading)) {
        // Jika sudah ada status definitif, GoRouter redirect seharusnya sudah bekerja.
        // Baris di bawah ini bisa jadi redundan jika redirect bekerja sempurna.
        _navigateBasedOnAuth(authState);
      }
    });
  }

  void _navigateBasedOnAuth(AuthState authState) {
    if (!mounted) return;
    print("Splash navigating based on auth: ${authState.status}");
    if (authState.status == AuthStatus.authenticated) {
      if (authState.user?.group == 'admin' ||
          authState.user?.group == 'superadmin') {
        context.go(AppRoute.adminDashboard.path);
      } else {
        context.go(AppRoute.employeeDashboard.path);
      }
    } else if (authState.status == AuthStatus.unauthenticated) {
      context.go(AppRoute.login.path);
    }
    // Jika status unknown/loading, GoRouter redirect akan menahan di splash
  }

  @override
  Widget build(BuildContext context) {
    // Dengarkan perubahan auth state untuk navigasi jika diperlukan
    // (meskipun GoRouter redirect adalah mekanisme utama)
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      print("Splash screen listening to auth changes: ${next.status}");
      if (next.status != AuthStatus.unknown &&
          next.status != AuthStatus.loading) {
        _navigateBasedOnAuth(next);
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.fingerprint, size: 100, color: Colors.white),
            const SizedBox(height: 20),
            Text(
              'Aplikasi Absensi Karyawan',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
