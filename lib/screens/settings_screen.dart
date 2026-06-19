import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:gal/gal.dart';

import '../db/database_helper.dart';
import '../theme/app_colors.dart';
import '../widgets/input_dialog.dart';

/// Halaman Settings: hapus semua data + dukung developer (QRIS).
///
/// Saat di-pop, mengembalikan `true` kalau ada data yang berubah (mis. semua
/// data dihapus), supaya Dashboard bisa refresh.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Path asset QRIS — taruh file-nya di assets/images/qris.png
  static const _qrisAsset = 'assets/images/qris.png';

  bool _dataChanged = false;

  Future<void> _hapusSemuaData() async {
    final ok = await showConfirmDialog(
      context,
      title: 'Hapus semua data?',
      message: 'SEMUA project & tugas (aktif maupun selesai) akan dihapus '
          'permanen dan tidak bisa dikembalikan.',
      confirmLabel: 'Hapus Semua',
    );
    if (!ok) return;
    await DatabaseHelper.instance.deleteAllData();
    _dataChanged = true;
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Semua data berhasil dihapus.')),
    );
  }

  Future<void> _simpanQris() async {
    try {
      // Baca file gambar dari assets.
      final data = await rootBundle.load(_qrisAsset);
      final bytes = data.buffer.asUint8List();
      await Gal.putImageBytes(bytes, name: 'qris_projecttracker');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('QRIS tersimpan ke galeri.')),
      );
    } on GalException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan: ${e.type.message}')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gambar QRIS belum tersedia di assets/images/qris.png'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) Navigator.pop(context, _dataChanged);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Pengaturan',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionLabel('Data'),
            Card(
              child: ListTile(
                leading: const Icon(Icons.delete_forever_outlined,
                    color: Colors.redAccent),
                title: const Text(
                  'Hapus semua data',
                  style: TextStyle(color: AppColors.textPrimary),
                ),
                subtitle: const Text(
                  'Menghapus seluruh project & tugas',
                  style: TextStyle(color: AppColors.textTertiary, fontSize: 12),
                ),
                onTap: _hapusSemuaData,
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionLabel('Dukung Developer'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.coffee_outlined, color: AppColors.accent),
                        SizedBox(width: 10),
                        Text(
                          'Buy me a coffee ☕',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildQrisImage(),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _simpanQris,
                        icon: const Icon(Icons.download),
                        label: const Text('Simpan QRIS ke Galeri'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: AppColors.textTertiary,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildQrisImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        _qrisAsset,
        fit: BoxFit.contain,
        // Kalau qris.png belum ada, tampilkan placeholder ramah.
        errorBuilder: (context, error, stack) => Container(
          height: 200,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.qr_code_2, size: 48, color: AppColors.textTertiary),
                SizedBox(height: 8),
                Text(
                  'QRIS belum ditambahkan',
                  style: TextStyle(color: AppColors.textTertiary),
                ),
                Text(
                  'Taruh di assets/images/qris.png',
                  style: TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
