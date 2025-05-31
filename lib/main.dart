// // lib/main.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '/routes/app_router.dart';
// import '/core/theme/app_theme.dart';
// import 'package:intl/date_symbol_data_local.dart';
// import 'package:shared_preferences/shared_preferences.dart'; // 1. Import SharedPreferences
// import '/data/datasources/local_datasource.dart'; // 2. Import LocalDatasource

// // 3. Buat provider untuk instance SharedPreferences
// // Provider ini akan di-override di ProviderScope dalam main()
// final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
//   throw UnimplementedError('SharedPreferences instance has not been provided/overridden');
// });

// void main() async {
//   // 4. Pastikan Flutter binding sudah siap
//   WidgetsFlutterBinding.ensureInitialized();
//   await initializeDateFormatting('id_ID', null);

//   // 5. Dapatkan instance SharedPreferences
//   final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

//   runApp(
//     ProviderScope(
//       overrides: [
//         // 6. Override sharedPreferencesProvider dengan instance yang sudah didapatkan
//         sharedPreferencesProvider.overrideWithValue(sharedPreferences),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends ConsumerWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // Baris ini seharusnya tidak lagi menyebabkan error karena dependency-nya sudah siap
//     final goRouter = ref.watch(goRouterProvider);

//     return MaterialApp.router(
//       title: 'Absensi Karyawan',
//       theme: AppTheme.lightTheme,
//       darkTheme: AppTheme.darkTheme,
//       themeMode: ThemeMode.light,
//       routerConfig: goRouter,
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart'; // Tidak terpakai langsung di sini
import '/routes/app_router.dart';
import '/core/theme/app_theme.dart';
import 'package:intl/date_symbol_data_local.dart'; // BARU: Untuk inisialisasi locale 'id_ID'

void main() async {
  // BARU: Ubah jadi async untuk await
  WidgetsFlutterBinding.ensureInitialized(); // BARU: Pastikan binding siap
  await initializeDateFormatting(
      'id_ID', null); // BARU: Inisialisasi locale untuk intl
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'Absensi Karyawan',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}

// lib/core/theme/app_theme.dart
// Tidak ada perubahan signifikan, tetap sama

// lib/core/constants/app_constants.dart
// Tidak ada perubahan signifikan, tetap sama

// lib/core/utils/ (Direktori BARU)
// Anda bisa menambahkan file utilitas di sini, misalnya:
// - lib/core/utils/date_formatter.dart
// - lib/core/utils/validators.dart
// (Untuk saat ini direktori ini kosong)

// lib/data/models/user_model.dart
// Tidak ada perubahan signifikan, tetap sama

// lib/data/models/attendance_model.dart
// Tidak ada perubahan signifikan, tetap sama

// BARU: lib/data/models/shift_model.dart
class Shift {
  final int id;
  final String name;
  final TimeOfDay startTime; // Menggunakan TimeOfDay untuk waktu
  final TimeOfDay endTime;
  // Tambahkan field lain jika ada (misal: toleransi keterlambatan, dll)

  Shift({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
  });

  factory Shift.fromJson(Map<String, dynamic> json) {
    // Fungsi parsing TimeOfDay dari String (HH:mm:ss atau HH:mm)
    TimeOfDay parseTimeOfDay(String timeStr) {
      final parts = timeStr.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }

    return Shift(
      id: json['id'] as int,
      name: json['name'] as String,
      startTime: parseTimeOfDay(json['start_time'] as String),
      endTime: parseTimeOfDay(json['end_time'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    // Fungsi format TimeOfDay ke String (HH:mm)
    String formatTimeOfDay(TimeOfDay tod) {
      final hour = tod.hour.toString().padLeft(2, '0');
      final minute = tod.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    }

    return {
      'id': id,
      'name': name,
      'start_time': formatTimeOfDay(startTime),
      'end_time': formatTimeOfDay(endTime),
    };
  }
}
