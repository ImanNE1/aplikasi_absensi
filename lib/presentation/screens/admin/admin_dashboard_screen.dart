import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/presentation/providers/auth_provider.dart';
import '/routes/app_router.dart'; // BARU
import 'package:go_router/go_router.dart'; // BARU

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authNotifierProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          Text(
            'Selamat Datang, Admin ${user?.name ?? ''}!',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Theme.of(context).primaryColor),
          ),
          Text(
            "ID: ${user?.id ?? 'N/A'} | Role: ${user?.group ?? 'N/A'}", // DEBUG
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Statistik Hari Ini',
                      style: Theme.of(context).textTheme.titleMedium),
                  const Divider(),
                  _buildStatItem(context, 'Karyawan Hadir', '50/60',
                      Icons.check_circle_outline, Colors.green),
                  _buildStatItem(context, 'Karyawan Terlambat', '5',
                      Icons.warning_amber_rounded, Colors.orange),
                  _buildStatItem(context, 'Karyawan Izin/Sakit', '2',
                      Icons.medical_services_outlined, Colors.blue),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildAdminMenuItem(
            context,
            icon: Icons.people_alt_outlined,
            title: 'Kelola Karyawan',
            onTap: () {
              context.goNamed(AppRoute.adminUserManagement.name); // BARU
            },
          ),
          _buildAdminMenuItem(
            context,
            icon: Icons.assessment_outlined,
            title: 'Laporan Absensi',
            onTap: () {
              context.goNamed(AppRoute.adminAttendanceReport.name); // BARU
            },
          ),
          _buildAdminMenuItem(
            context,
            icon: Icons.more_time_outlined,
            title: 'Kelola Shift',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content:
                        Text('Halaman Kelola Shift belum diimplementasikan.')),
              );
              // context.goNamed(AppRoute.adminShiftManagement.name);
            },
          ),
          _buildAdminMenuItem(
            context,
            icon: Icons.qr_code_2_outlined,
            title: 'Kelola Barcode QR',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                        'Halaman Kelola Barcode QR belum diimplementasikan.')),
              );
              // context.goNamed(AppRoute.adminBarcodeManagement.name);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String title, String value,
      IconData icon, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Text(title, style: Theme.of(context).textTheme.bodyMedium),
          const Spacer(),
          Text(value,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildAdminMenuItem(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }
}
