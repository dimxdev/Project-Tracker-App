<div align="center">

# 📌 Project Tracker

### *Inbox cepat buat nampung ide fitur & bug per project — biar gak ada ide yang hilang* 💡

[![Flutter](https://img.shields.io/badge/Flutter-3.44-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.12-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![SQLite](https://img.shields.io/badge/SQLite-sqflite-003B57?logo=sqlite&logoColor=white)](https://pub.dev/packages/sqflite)
[![Platform](https://img.shields.io/badge/Platform-Android-3DDC84?logo=android&logoColor=white)](#)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](#-lisensi)

</div>

---

## 🎯 Tentang Project

Punya beberapa project yang udah di-deploy? Sering kepikiran **ide fitur baru** atau nemu **bug** secara spontan, tapi gak langsung dikerjain — terus idenya **hilang** karena gak dicatat? 😩

**Project Tracker** hadir sebagai *"inbox" cepat* buat nampung ide/bug per project. Catat sekali, eksekusi nanti. Simpel, gelap, anti-ribet — dibuka sekilas, langsung catat. ⚡

> 🗂️ Setiap **project** punya kumpulan **task** (catatan bebas: ide fitur / bug). Task cuma punya 2 status: **aktif** atau **selesai**. Gak ribet.

---

## ✨ Fitur

| | Fitur | Keterangan |
|:---:|---|---|
| 📋 | **Dashboard** | Daftar project bentuk *expandable card* + badge jumlah task aktif |
| ➕ | **CRUD Task** | Tambah, edit, hapus, & tandai selesai — semua dengan konfirmasi |
| ⚡ | **Tambah Cepat** | Form global "Tambah List Tugas" dengan dropdown pilih project |
| 🗃️ | **Riwayat** | Arsip task selesai, dikelompokkan per project, bisa dihapus |
| ✏️ | **Kelola Project** | Ubah nama & hapus project (lewat menu ⋮) |
| 🔠 | **Auto Title Case** | `"project ini"` → `"Project Ini"` otomatis |
| 🌙 | **Dark Theme** | Tema gelap minimalis dengan aksen *teal* |
| 💾 | **Offline 100%** | Data tersimpan lokal via SQLite — tanpa akun, tanpa internet |
| ☕ | **Buy Me a Coffee** | Halaman dukungan dengan QRIS (bisa disimpan ke galeri) |

---

## 🛠️ Tech Stack

- **Framework:** Flutter (Dart)
- **Database:** SQLite via [`sqflite`](https://pub.dev/packages/sqflite)
- **Simpan ke galeri:** [`gal`](https://pub.dev/packages/gal)
- **App icon:** [`flutter_launcher_icons`](https://pub.dev/packages/flutter_launcher_icons)
- **State management:** `setState` (sengaja simpel — utility app pribadi)

---

## 🎨 Palet Warna

| Elemen | Warna | |
|---|---|:---:|
| Background | `#14181A` | ⬛ |
| Surface / Card | `#1A2022` | ⬛ |
| Aksen (teal) | `#5DCAA5` | 🟩 |
| Teks Primer | `#F1F3F2` | ⬜ |

---

## 🗂️ Struktur Project

```
lib/
├── main.dart              # Entry point + setup tema & system UI
├── theme/                 # Palet warna & ThemeData
│   ├── app_colors.dart
│   └── app_theme.dart
├── models/                # Model data (Project, Task)
│   ├── project.dart
│   └── task.dart
├── db/                    # Database helper SQLite
│   └── database_helper.dart
├── screens/               # Halaman utama
│   ├── main_shell.dart    # Bottom navigation
│   ├── dashboard_screen.dart
│   ├── history_screen.dart
│   └── settings_screen.dart
├── widgets/               # Komponen reusable
│   ├── project_card.dart
│   ├── task_item.dart
│   ├── add_task_sheet.dart
│   └── input_dialog.dart
└── utils/
    └── text_format.dart   # Helper Title Case
```

---

## 🚀 Cara Menjalankan

**Prasyarat:** [Flutter SDK](https://docs.flutter.dev/get-started/install) sudah terpasang.

```bash
# 1. Clone repo
git clone <url-repo-kamu>
cd ProjectTrackerApp

# 2. Install dependencies
flutter pub get

# 3. Jalankan (emulator / HP harus nyala)
flutter run
```

### 📦 Build APK

```bash
flutter build apk --release
```

Hasilnya ada di:
```
build/app/outputs/flutter-apk/app-release.apk
```

Tinggal transfer ke HP & install manual (izinkan *"install dari sumber tidak dikenal"*). 📲

### 🖼️ Ganti App Icon (opsional)

```bash
# Taruh gambar 1024x1024 di assets/icon/app_icon.png, lalu:
dart run flutter_launcher_icons
```

---

## 🗄️ Struktur Database

**`projects`**
| Kolom | Tipe | Keterangan |
|---|---|---|
| id | INTEGER PK | Auto increment |
| name | TEXT | Nama project |
| created_at | TEXT | Waktu dibuat |

**`tasks`**
| Kolom | Tipe | Keterangan |
|---|---|---|
| id | INTEGER PK | Auto increment |
| project_id | INTEGER FK | Relasi ke `projects.id` (ON DELETE CASCADE) |
| content | TEXT | Isi catatan (ide/bug) |
| is_done | INTEGER | 0 = aktif, 1 = selesai |
| created_at | TEXT | Waktu dibuat |
| completed_at | TEXT | Waktu selesai (nullable) |

---

## 🗺️ Roadmap

- [x] CRUD project & task
- [x] Riwayat task selesai
- [x] Dark theme + bottom navigation
- [x] Hapus semua data & Buy me a coffee (QRIS)
- [x] Custom app icon
- [ ] 🔍 Search / filter project
- [ ] 🎨 Icon / warna custom per project
- [ ] ☁️ Backup / restore data

---

## ☕ Dukung Developer

Kalau app ini bermanfaat, boleh banget traktir kopi lewat QRIS di dalam app (menu **Settings → Buy me a coffee**). Makasih! 🙏

---

## 📄 Lisensi

Project ini dirilis di bawah lisensi **MIT** — bebas dipakai & dimodifikasi.

---

<div align="center">

Dibuat dengan ❤️ & ☕ menggunakan Flutter

⭐ *Star repo ini kalau bermanfaat!*

</div>
# Project-Tracker-App
