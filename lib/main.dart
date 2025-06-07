

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
import '/routes/app_router.dart';
import '/core/theme/app_theme.dart';
import 'package:intl/date_symbol_data_local.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await initializeDateFormatting(
      'id_ID', null);
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

class Shift {
  final int id;
  final String name;
  final TimeOfDay startTime; // Menggunakan TimeOfDay untuk waktu
  final TimeOfDay endTime;

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
