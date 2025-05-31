import 'package:flutter/material.dart';

class EmployeeAttendanceHistoryScreen extends StatelessWidget {
  const EmployeeAttendanceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Absensi Saya'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 10, // Contoh data
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(
                Icons.calendar_today_outlined,
                color: Theme.of(context).primaryColor,
              ),
              title: Text('Tanggal ${20 - index} Mei 2024',
                  style: Theme.of(context).textTheme.titleSmall),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Masuk: 08:${index.toString().padLeft(2, '0')} - Keluar: 17:0${index % 5}'),
                  Text('Status: Hadir',
                      style: TextStyle(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Tampilkan detail absensi
              },
            ),
          );
        },
      ),
    );
  }
}
