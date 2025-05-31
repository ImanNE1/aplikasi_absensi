import 'package:flutter/material.dart';

class AdminUserManagementScreen extends StatelessWidget {
  const AdminUserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Karyawan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Tambah Karyawan',
            onPressed: () {
              // TODO: Tampilkan form tambah karyawan
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5, // Contoh data
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    Theme.of(context).primaryColor.withOpacity(0.2),
                child: Text('${index + 1}',
                    style: TextStyle(color: Theme.of(context).primaryColor)),
              ),
              title: Text('Nama Karyawan ${index + 1}',
                  style: Theme.of(context).textTheme.titleSmall),
              subtitle: Text('NIP: 1234567${index} | Divisi: IT'),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  // TODO: Handle aksi edit/hapus
                  print('Aksi: $value untuk Karyawan ${index + 1}');
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'edit',
                    child: Text('Edit'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: Text('Hapus', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
              onTap: () {
                // TODO: Tampilkan detail karyawan
              },
            ),
          );
        },
      ),
    );
  }
}
