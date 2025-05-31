import 'package:flutter/material.dart';

class AdminAttendanceReportScreen extends StatelessWidget {
  const AdminAttendanceReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Absensi Karyawan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_alt),
            tooltip: 'Filter Laporan',
            onPressed: () {
              // TODO: Tampilkan dialog filter
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Halaman Laporan Absensi (Belum Diimplementasikan)',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
