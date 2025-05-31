import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart'; // Jika perlu akses provider

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool _isProcessing = false;
  String? _scannedValue;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void _handleBarcode(BarcodeCapture capture) {
    if (_isProcessing) return; // Hindari multiple scan sekaligus

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
      setState(() {
        _isProcessing = true;
        _scannedValue = barcodes.first.rawValue;
      });

      // Tampilkan dialog atau snackbar dengan hasil scan
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('QR Code Terdeteksi'),
          content: Text(
              'Nilai QR: $_scannedValue\n\n(Implementasi: Kirim nilai ini ke API untuk proses absensi)'),
          actions: [
            TextButton(
              child: const Text('Tutup & Scan Ulang'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _isProcessing = false; // Izinkan scan lagi
                  _scannedValue = null;
                });
              },
            ),
            ElevatedButton(
              child: const Text('Proses Absen (Dummy)'),
              onPressed: () {
                // TODO: Panggil API untuk proses absensi dengan _scannedValue
                Navigator.of(context).pop(); // Tutup dialog
                // Mungkin kembali ke dashboard atau tampilkan pesan sukses/gagal
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'Proses absensi untuk QR: $_scannedValue (belum diimplementasikan)')),
                );
                setState(() {
                  // Reset untuk scan berikutnya
                  _isProcessing = false;
                  _scannedValue = null;
                });
              },
            ),
          ],
        ),
      ).then((_) {
        // Jika dialog ditutup dengan cara lain (misal back button), pastikan _isProcessing direset
        if (mounted && _isProcessing) {
          setState(() {
            _isProcessing = false;
            _scannedValue = null;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Absensi'),
        actions: [
          // Tombol untuk Torch (Senter)
          ValueListenableBuilder<TorchState>(
            // Menambahkan tipe eksplisit <TorchState>
            valueListenable: cameraController.torchState,
            builder: (BuildContext context, TorchState state, Widget? child) {
              // Menambahkan tipe eksplisit
              // Ikon dan aksi IconButton sekarang dikembalikan berdasarkan state
              switch (state) {
                case TorchState.off:
                  return IconButton(
                    color: Colors
                        .white, // Pastikan Colors.white, bukan colors.white
                    icon: const Icon(Icons.flash_off_rounded),
                    tooltip: 'Nyalakan senter',
                    iconSize: 32.0, // Pindahkan iconSize ke dalam IconButton
                    onPressed: () => cameraController.toggleTorch(),
                  );
                case TorchState.on:
                  return IconButton(
                    color: Colors.white,
                    icon: const Icon(Icons.flash_on_rounded,
                        color: Colors.yellow),
                    tooltip: 'Matikan senter',
                    iconSize: 32.0, // Pindahkan iconSize ke dalam IconButton
                    onPressed: () => cameraController.toggleTorch(),
                  );
                // Tidak perlu default karena TorchState hanya memiliki 'off' dan 'on'
                // Namun, jika analyzer meminta, Anda bisa tambahkan:
                // default: return SizedBox.shrink(); // atau ikon default
                case TorchState.auto:
                  // TODO: Handle this case.
                  throw UnimplementedError();
                case TorchState.unavailable:
                  // TODO: Handle this case.
                  throw UnimplementedError();
              }
            },
          ),
          // Tombol untuk mengganti kamera (Depan/Belakang)
          ValueListenableBuilder<CameraFacing>(
            // Menambahkan tipe eksplisit <CameraFacing>
            valueListenable: cameraController.cameraFacingState,
            builder: (BuildContext context, CameraFacing state, Widget? child) {
              // Menambahkan tipe eksplisit
              // Ikon dan aksi IconButton sekarang dikembalikan berdasarkan state
              switch (state) {
                case CameraFacing.front:
                  return IconButton(
                    color: Colors.white,
                    icon: const Icon(Icons.camera_front_rounded),
                    tooltip: 'Ganti ke kamera belakang',
                    iconSize: 32.0, // Pindahkan iconSize ke dalam IconButton
                    onPressed: () => cameraController.switchCamera(),
                  );
                case CameraFacing.back:
                  return IconButton(
                    color: Colors.white,
                    icon: const Icon(Icons.camera_rear_rounded),
                    tooltip: 'Ganti ke kamera depan',
                    iconSize: 32.0, // Pindahkan iconSize ke dalam IconButton
                    onPressed: () => cameraController.switchCamera(),
                  );
                // Tidak perlu default karena CameraFacing hanya memiliki 'front' dan 'back'
                // default: return SizedBox.shrink(); // atau ikon default
              }
            },
          ),
        ],
      ),
      body: Stack(
        // ... (sisa kode body Anda tetap sama) ...
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: _handleBarcode,
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.width * 0.7,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).primaryColor.withOpacity(0.7),
                    width: 3), // Sesuaikan warna dengan tema Anda
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.black.withOpacity(0.5),
              child: Text(
                _isProcessing
                    ? 'Memproses: $_scannedValue'
                    : 'Arahkan kamera ke QR Code Absensi',
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension on MobileScannerController {
  get torchState => null;

  get cameraFacingState => null;
}
