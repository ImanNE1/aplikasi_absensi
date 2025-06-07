import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/presentation/screens/splash_screen.dart';
import '/presentation/screens/auth/login_screen.dart';
import '/presentation/screens/employee/employee_dashboard_screen.dart';
import '/presentation/screens/employee/qr_scanner_screen.dart';
import '/presentation/screens/employee/employee_attendance_history_screen.dart'; // BARU
import '/presentation/screens/admin/admin_dashboard_screen.dart';
import '/presentation/screens/admin/admin_user_management_screen.dart'; // BARU
import '/presentation/screens/admin/admin_attendance_report_screen.dart'; // BARU
import '/presentation/providers/auth_provider.dart';

enum AppRoute {
  splash,
  login,
  employeeDashboard,
  employeeQRScan,
  employeeAttendanceHistory, 
  adminDashboard,
  adminUserManagement, 
  adminAttendanceReport, 
  adminShiftManagement, 
  adminBarcodeManagement,
}

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(); 

// Daftar path yang dapat diakses publik tanpa login
final List<String> publicRoutes = [
  AppRoute.splash.path,
  AppRoute.login.path,
];

final goRouterProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref
      .watch(authNotifierProvider.notifier); // Untuk akses notifier jika perlu

  // Menggunakan listen untuk memantau perubahan authState agar GoRouter bisa refresh
  final refreshListenable = ValueNotifier<int>(0);
  ref.listen<AuthState>(authNotifierProvider, (_, next) {
    refreshListenable.value++; // Trigger GoRouter untuk re-evaluate redirect
  });

  return GoRouter(
    navigatorKey: _rootNavigatorKey, // BARU
    initialLocation: AppRoute.splash.path, // BARU: Gunakan path dari enum
    debugLogDiagnostics: true,
    refreshListenable: refreshListenable, // BARU
    redirect: (BuildContext context, GoRouterState state) {
      final currentAuthState = ref.read(authNotifierProvider);
      final isLoggedIn = currentAuthState.status == AuthStatus.authenticated;
      final userRole = currentAuthState.user?.group;

      print("--- GoRouter Redirect ---"); // DEBUG
      print("Current Location: ${state.matchedLocation}"); // DEBUG
      print("Auth Status: ${currentAuthState.status}"); // DEBUG
      print("Is Logged In: $isLoggedIn"); // DEBUG
      print("User Role: $userRole"); // DEBUG
      print("User Object: ${currentAuthState.user?.name}"); // DEBUG

      // ... sisa logika redirect Anda ...
      // Tambahkan print() sebelum setiap return untuk melihat path mana yang dipilih
      if (!isLoggedIn && !publicRoutes.contains(state.matchedLocation)) {
        print("Redirecting to: ${AppRoute.login.path}"); // DEBUG
        return AppRoute.login.path;
      }
      if (isLoggedIn && state.matchedLocation == AppRoute.login.path) {
        final targetPath = (userRole == 'admin' || userRole == 'superadmin')
            ? AppRoute.adminDashboard.path
            : AppRoute.employeeDashboard.path;
        print("Redirecting to: $targetPath"); // DEBUG
        return targetPath;
      }
      // ...
      print("No redirect needed."); // DEBUG
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoute.splash.path,
        name: AppRoute.splash.name,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoute.login.path,
        name: AppRoute.login.name,
        builder: (context, state) => const LoginScreen(),
      ),
      // Employee Routes Shell (Contoh jika ingin BottomNav)
      // ShellRoute(
      //   navigatorKey: GlobalKey<NavigatorState>(), // Kunci berbeda untuk Shell
      //   builder: (context, state, child) => EmployeeShellScreen(child: child), // Buat EmployeeShellScreen
      //   routes: [
      GoRoute(
          path: AppRoute.employeeDashboard.path,
          name: AppRoute.employeeDashboard.name,
          builder: (context, state) => const EmployeeDashboardScreen(),
          routes: [
            GoRoute(
              path: 'qr-scan',
              name: AppRoute.employeeQRScan.name,
              builder: (context, state) => const QRScannerScreen(),
            ),
            GoRoute(
              // BARU
              path: 'history',
              name: AppRoute.employeeAttendanceHistory.name,
              builder: (context, state) =>
                  const EmployeeAttendanceHistoryScreen(),
            ),
          ]),
      //   ]
      // ),

      // Admin Routes Shell (Contoh jika ingin BottomNav/Drawer)
      // ShellRoute(
      //   navigatorKey: GlobalKey<NavigatorState>(),
      //   builder: (context, state, child) => AdminShellScreen(child: child), // Buat AdminShellScreen
      //   routes: [
      GoRoute(
          path: AppRoute.adminDashboard.path,
          name: AppRoute.adminDashboard.name,
          builder: (context, state) => const AdminDashboardScreen(),
          routes: [
            // BARU: Sub-rute untuk admin
            GoRoute(
              path: 'users',
              name: AppRoute.adminUserManagement.name,
              builder: (context, state) => const AdminUserManagementScreen(),
            ),
            GoRoute(
              path: 'reports',
              name: AppRoute.adminAttendanceReport.name,
              builder: (context, state) => const AdminAttendanceReportScreen(),
            ),
            // Tambahkan rute untuk shift dan barcode management
            // GoRoute(path: 'shifts', name: AppRoute.adminShiftManagement.name, ...),
            // GoRoute(path: 'barcodes', name: AppRoute.adminBarcodeManagement.name, ...),
          ]),
      //   ]
      // ),
    ],
  );
});

// Helper untuk path route dari enum (BARU)
extension AppRoutePath on AppRoute {
  String get path {
    switch (this) {
      case AppRoute.splash:
        return '/splash';
      case AppRoute.login:
        return '/login';
      case AppRoute.employeeDashboard:
        return '/employee/dashboard';
      case AppRoute.employeeQRScan:
        return '/employee/dashboard/qr-scan'; // Path lengkap untuk sub-rute
      case AppRoute.employeeAttendanceHistory:
        return '/employee/dashboard/history'; // Path lengkap untuk sub-rute
      case AppRoute.adminDashboard:
        return '/admin/dashboard';
      case AppRoute.adminUserManagement:
        return '/admin/dashboard/users'; // Path lengkap untuk sub-rute
      case AppRoute.adminAttendanceReport:
        return '/admin/dashboard/reports'; // Path lengkap untuk sub-rute
      // Tambahkan path untuk adminShiftManagement dan adminBarcodeManagement
      default:
        return '/';
    }
  }
}
