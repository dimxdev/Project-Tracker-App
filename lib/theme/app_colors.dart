import 'package:flutter/material.dart';

/// Palet warna aplikasi, diambil persis dari project-spec.md.
/// Semua warna dipusatkan di sini biar gampang diubah dari satu tempat.
class AppColors {
  AppColors._(); // class ini cuma wadah konstanta, gak perlu di-instance.

  /// Background utama layar (dark netral, bukan hitam pekat).
  static const Color background = Color(0xFF14181A);

  /// Warna permukaan card / panel.
  static const Color surface = Color(0xFF1A2022);

  /// Border tipis di card.
  static const Color border = Color(0xFF2A3234);

  /// Teks utama (paling terang).
  static const Color textPrimary = Color(0xFFF1F3F2);

  /// Teks sekunder (sedikit lebih redup).
  static const Color textSecondary = Color(0xFFC7CCCA);

  /// Teks tersier / ikon non-aktif (paling redup).
  static const Color textTertiary = Color(0xFF6B7572);

  /// Warna aksen utama (tombol, badge, ikon aktif) — teal.
  static const Color accent = Color(0xFF5DCAA5);

  /// Teks/ikon di ATAS warna aksen teal (gelap biar kontras).
  static const Color onAccent = Color(0xFF04342C);
}
