# Project Tracker App — Spesifikasi

## Latar Belakang
Punya beberapa project yang udah di-deploy. Sering kepikiran ide fitur baru atau bug yang perlu diperbaiki secara spontan, tapi gak langsung dikerjain saat itu juga sehingga ide tersebut bisa hilang kalau gak dicatat. App ini berfungsi sebagai "inbox" cepat untuk menampung ide/bug per project, supaya gak hilang dan bisa dieksekusi nanti.

## Tech Stack
- **Framework:** Flutter (Dart)
- **Database:** SQLite, menggunakan package `sqflite`
- **IDE:** VS Code
- **Target:** Android (output APK, install manual, tidak publish ke Play Store)
- **Skill level:** Pemula di Android/Flutter development
- **Prioritas:** Cepat jadi dan kepake untuk diri sendiri (bukan untuk belajar konsep secara mendalam)

## Konsep Inti
Setiap **project** (kategori) yang sudah dideploy user, punya kumpulan **task** (catatan bebas berupa ide fitur/bug). Task tidak dikategorikan jenisnya (tidak ada label "fitur" vs "bug" terpisah — cukup teks bebas). Task tidak punya status progress bertingkat (tidak ada "belum/sedang/selesai dikerjakan") — hanya aktif atau selesai (biner).

## Struktur Data

### Tabel `projects`
| Kolom | Tipe | Keterangan |
|---|---|---|
| id | INTEGER PK | Auto increment |
| name | TEXT | Nama project |
| created_at | TEXT/DATETIME | Waktu dibuat |

### Tabel `tasks`
| Kolom | Tipe | Keterangan |
|---|---|---|
| id | INTEGER PK | Auto increment |
| project_id | INTEGER FK | Relasi ke `projects.id` |
| content | TEXT | Isi catatan tugas (fitur/bug, bebas teks) |
| is_done | BOOLEAN/INTEGER | 0 = aktif, 1 = selesai |
| created_at | TEXT/DATETIME | Waktu dibuat |
| completed_at | TEXT/DATETIME | Waktu ditandai selesai (nullable) |

## Halaman & Flow

### 1. Dashboard (halaman utama)
- Menampilkan daftar project dalam bentuk **expandable/dropdown list**.
- Tiap project card menampilkan nama project + badge jumlah task aktif.
- Saat di-tap/expand, menampilkan daftar task aktif di project tersebut.
- Tiap task item punya 3 aksi: **edit teks**, **hapus**, **tandai selesai**.
  - Tandai selesai → task otomatis pindah ke halaman Riwayat (tidak hilang, tapi tidak lagi muncul di Dashboard).
- Di dalam project card yang sedang expand, ada tombol cepat "Tambah tugas" untuk menambah task langsung ke project itu tanpa keluar dari card.
- Ada tombol "Tambah Project" untuk membuat kategori/project baru (form sederhana: input nama project).
- Ada tombol "Tambah List Tugas" terpisah (lebih global) — membuka form dengan dropdown pilih project + input teks tugas. Berguna saat user ingin mencatat cepat tanpa navigasi ke project spesifik dulu.

### 2. Riwayat
- Menampilkan semua task yang sudah ditandai selesai.
- Dikelompokkan per project.
- Bersifat **read-only** (arsip/kenang-kenangan, bukan untuk dikerjakan ulang).

### Navigasi
- Bottom navigation bar dengan 2 menu: **Dashboard** dan **Riwayat**.

## Desain UI/UX

### Arah Visual
- **Dark theme**, clean, minim, tidak ribet (utility app yang dibuka sekilas).
- Warna aksen: **teal/hijau kebiruan**.

### Detail Palet (referensi)
| Elemen | Warna |
|---|---|
| Background utama | `#14181A` (dark netral, bukan hitam pekat) |
| Surface/card | `#1A2022` |
| Border card | `#2A3234` (0.5px) |
| Teks primer | `#F1F3F2` |
| Teks sekunder | `#C7CCCA` |
| Teks tersier/ikon non-aktif | `#6B7572` |
| Aksen (tombol, badge, ikon aktif) | `#5DCAA5` (teal) |
| Teks di atas aksen teal | `#04342C` (gelap, kontras) |

### Komponen Kunci
- Project card: rounded corner, border tipis, badge angka jumlah task aktif di kanan.
- Task item: teks di kiri, 3 ikon aksi kecil di kanan (check, edit, trash).
- Tombol utama "Tambah tugas" pakai warna aksen teal solid (filled), tombol sekunder "Tambah project" pakai outline/border style.
- Bottom nav: 2 item (Dashboard, Riwayat), ikon aktif berwarna teal, non-aktif abu-abu.

## Scope MVP (Versi Pertama)
Yang termasuk:
- CRUD project (tambah, lihat, hapus — belum tentu perlu edit nama project, bisa didiskusikan)
- CRUD task (tambah, edit teks, hapus, tandai selesai)
- Riwayat task selesai (read-only)
- Local storage via SQLite, tanpa akun/login/cloud sync

Yang TIDAK termasuk di MVP (sengaja disederhanakan):
- Kategori/jenis task (fitur vs bug vs ide)
- Status progress bertingkat (belum/sedang/selesai)
- Sync antar device / cloud backend
- Publish ke Play Store

## Output Build
- Development & testing via emulator atau device fisik (USB debugging).
- Build akhir: `flutter build apk` menghasilkan file `.apk`.
- Install manual ke HP (perlu izinkan "install dari sumber tidak dikenal").

## Catatan untuk Lanjutan Development
Hal yang masih bisa didiskusikan lebih lanjut saat mulai coding:
- Apakah nama project bisa di-edit setelah dibuat, atau hanya tambah/hapus.
- Apakah perlu konfirmasi (dialog) sebelum hapus project (mengingat akan menghapus semua task di dalamnya) atau hapus task.
- Urutan task di dalam project (berdasarkan tanggal dibuat, terbaru di atas/bawah).
- Apakah perlu search/filter project jika jumlah project sudah banyak.
- Icon atau warna custom per project untuk visual differentiation (opsional, belum diputuskan).
