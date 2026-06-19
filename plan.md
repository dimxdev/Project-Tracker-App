# Plan Pengerjaan — Project Tracker App

Urutan kerja dari nol sampai jadi APK. Tiap tahap punya **target jelas** dan **checkpoint** (cara mastiin tahap itu beres sebelum lanjut). Dikerjakan berurutan biar gak bingung.

> Catatan: kamu pemula di Flutter, jadi tiap tahap sengaja kecil & bisa dites satu-satu. Jangan loncat tahap.

---

## Tahap 0 — Persiapan Lingkungan (sekali aja di awal)
Tujuan: mastiin laptop siap buat Flutter sebelum nulis kode.

- [ ] Install **Flutter SDK** + tambahkan ke PATH
- [ ] Install **Android Studio** (buat Android SDK + emulator) atau siapin HP fisik (USB debugging)
- [ ] Install extension **Flutter** & **Dart** di VS Code
- [ ] Jalankan `flutter doctor` → pastikan semua centang hijau (minimal Flutter, Android toolchain, dan satu device)

**Checkpoint:** `flutter doctor` gak ada error merah, dan ada minimal 1 device/emulator kedeteksi (`flutter devices`).

---

## Tahap 1 — Bikin Proyek & Jalanin Template Kosong ✅ SELESAI
Tujuan: punya app Flutter yang bisa jalan (belum ada fitur, cuma mastiin pipeline build OK).

- [x] `flutter create` di folder ini (package: `project_tracker_app`, org: `com.brotowali`, platform: android)
- [x] Build APK debug sukses (terbukti path dengan spasi aman di Flutter 3.44) → install ke emulator Pixel 5 (API 34)
- [x] Bersihin `main.dart` dari kode counter, ganti jadi halaman kosong (`ProjectTrackerApp` + teks "Project Tracker App")
- [x] App terbukti jalan di emulator (verified via screenshot)

**Checkpoint:** ✅ App nyala di device, layar tampil "Project Tracker App" tanpa crash.

---

## Tahap 2 — Setup Tema & Struktur Folder ✅ SELESAI
Tujuan: pasang dark theme + warna aksen teal dulu, dan rapihin struktur folder biar gampang nambah fitur.

- [x] Bikin struktur folder: `lib/theme/`, `lib/models/`, `lib/db/`, `lib/screens/`, `lib/widgets/`
- [x] Definisikan palet warna dari spec di `theme/app_colors.dart` (`#14181A`, `#1A2022`, `#5DCAA5`, dst)
- [x] Pasang `ThemeData` dark + warna aksen ke `MaterialApp` (`theme/app_theme.dart`)
- [x] Fix `widget_test.dart` (referensi class lama) → `flutter analyze` bersih

**Checkpoint:** ✅ Background app jadi gelap (`#14181A`) + aksen teal, terverifikasi via screenshot.

---

## Tahap 3 — Model Data (Dart Class) ✅ SELESAI
Tujuan: bikin representasi data di Dart sebelum nyentuh database.

- [x] Class `Project` (id, name, createdAt) + `toMap()` / `fromMap()` / `copyWith()` → `models/project.dart`
- [x] Class `Task` (id, projectId, content, isDone, createdAt, completedAt) + `toMap()` / `fromMap()` / `copyWith()` → `models/task.dart` (is_done ↔ 0/1)

**Checkpoint:** ✅ Class kompilasi tanpa error (`flutter analyze` bersih).

---

## Tahap 4 — Database SQLite (Lapisan Data) ✅ SELESAI
Tujuan: bikin "mesin" simpan/ambil data. Ini fondasi — UI nanti tinggal manggil fungsi di sini.

- [x] Tambah package `sqflite 2.4.3` + `path` di `pubspec.yaml`
- [x] Bikin `DatabaseHelper` (singleton): buka DB, bikin tabel `projects` & `tasks`, foreign key ON DELETE CASCADE
- [x] Fungsi CRUD Project: `insertProject`, `getProjects`, `updateProject`, `deleteProject`
- [x] Fungsi CRUD Task: `insertTask`, `getActiveTasks(projectId)`, `getDoneTasks()`, `updateTask`, `markTaskDone(taskId)`, `deleteTask`
- [x] `activeTaskCounts()` → Map {projectId: jumlah} buat badge

**Checkpoint:** ✅ Tes via layar sementara: 4 project + badge "2" muncul, data tetap ada setelah app di-restart (persistensi SQLite terbukti).

---

## Tahap 5 — Halaman Dashboard (Inti Aplikasi) ✅ SELESAI
Tujuan: bikin layar utama. Dikerjakan bertahap dari nampilin → interaksi.

- [x] **5a.** Daftar project sebagai **expandable card** (`widgets/project_card.dart`) + badge jumlah task aktif (teal kalau >0, abu kalau 0)
- [x] **5b.** Saat di-expand, tampilkan daftar task aktif (lazy-load dari DB)
- [x] **5c.** Tombol **"Tambah Project"** outline (dialog input nama → simpan → refresh)
- [x] **5d.** Tombol **"Tambah tugas"** teal solid di dalam card
- [x] **5e.** Aksi **tandai selesai** (`markTaskDone`, hilang dari Dashboard)
- [x] **5f.** Aksi **edit teks** (dialog edit)
- [x] **5g.** Aksi **hapus** task
- [x] Empty state + dialog reusable (`widgets/input_dialog.dart`) + item task (`widgets/task_item.dart`)

**Checkpoint:** ✅ Bisa bikin project, tambah/edit/hapus/selesaikan task — data tersimpan & badge update otomatis.

---

## Tahap 6 — Form "Tambah List Tugas" Global ✅ SELESAI
Tujuan: shortcut catat cepat tanpa masuk ke project dulu.

- [x] Tombol global "Tambah List Tugas" (filled teal) buka bottom sheet: **dropdown pilih project** + input teks (`widgets/add_task_sheet.dart`)
- [x] Simpan → task masuk ke project terpilih, Dashboard refresh
- [x] Fix: card yang lagi expand auto-reload task saat badge berubah (`didUpdateWidget`)

**Checkpoint:** ✅ Tambah task dari form global langsung muncul di project yang benar + card yang kebuka ikut update.

---

## Tahap 7 — Halaman Riwayat ✅ SELESAI
Tujuan: arsip task selesai, read-only.

- [x] Ambil semua task `is_done = 1`, **kelompokkan per project** (`screens/history_screen.dart`)
- [x] Tampilkan read-only (centang hijau + tanggal selesai, gak ada aksi)
- [x] Empty state + nav sementara via ikon riwayat di AppBar Dashboard (diganti bottom nav di Tahap 8)
- [x] Hapus strikethrough (penanda selesai cukup dari ikon + tanggal)

**Checkpoint:** ✅ Task selesai muncul di Riwayat, dikelompokkan per project, read-only.

---

## Tahap 8 — Bottom Navigation ✅ SELESAI
Tujuan: hubungkan 2 halaman.

- [x] `MainShell` dengan bottom nav 2 item: **Dashboard** & **Riwayat**
- [x] Ikon aktif teal, non-aktif abu-abu (dari `bottomNavigationBarTheme`)
- [x] Pindah tab → layar fresh (Riwayat auto-nampilin task terbaru yg diselesaikan)
- [x] Hapus ikon riwayat sementara dari AppBar Dashboard

**Checkpoint:** ✅ Bisa bolak-balik Dashboard ↔ Riwayat lewat bottom nav.

---

## Tahap 9 — Polish UI/UX ✅ SELESAI
Tujuan: rapihin tampilan biar sesuai arah visual di spec.

- [x] Project card (rounded corner, border tipis `#2A3234`, badge di kanan)
- [x] Task item (teks kiri, 3 ikon aksi kecil di kanan: check / edit / trash)
- [x] Tombol utama teal solid (filled), tombol sekunder outline
- [x] Empty state Dashboard & Riwayat
- [x] SnackBar gelap floating + status bar/nav bar nyatu background gelap
- [x] **Bonus:** halaman Settings (hapus semua data + Buy me a coffee QRIS simpan ke galeri)
- [x] **Bonus:** auto Title Case saat input project/task ("project ini" → "Project Ini")

**Checkpoint:** ✅ Tampilan konsisten dark + teal, nyaman dipakai.

---

## Tahap 10 — Keputusan Detail ✅ SELESAI (diputuskan sambil jalan)
- [x] Nama project **bisa di-edit** (lewat menu ⋮)
- [x] **Hapus project** ada konfirmasi (ingatkan semua task ikut terhapus); hapus task & tandai selesai juga pakai konfirmasi
- [x] Urutan task: **terbaru di atas** (`ORDER BY created_at DESC`)
- [x] Search/filter & icon/warna custom per project → ditunda (bukan MVP)
- [x] **Tambahan owner:** Riwayat bisa dihapus (per task & per kategori)

---

## Tahap 11 — Tes Menyeluruh & Build APK ✅ HAMPIR SELESAI
Tujuan: hasil akhir bisa diinstall di HP.

- [x] Tes full flow di emulator: project → task (tambah/edit/hapus/selesai) → Riwayat
- [x] Tes restart app (data persist via SQLite)
- [x] `flutter build apk --release` → `app-release.apk` (47.5 MB)
- [x] Nama app di HP = "Project Tracker" (android:label)
- [x] Versi release diinstall & terbukti jalan di emulator (verified via screenshot)
- [ ] Install `.apk` manual ke HP fisik (izinkan "install dari sumber tidak dikenal") ← TINGGAL INI
- [ ] Pakai beneran sehari-hari, catat bug kecil buat diperbaiki

**Lokasi APK:** `build/app/outputs/flutter-apk/app-release.apk`

**Checkpoint:** ✅ APK release jadi & jalan. Tinggal transfer ke HP fisik.

---

## Ringkasan Urutan
```
0. Setup lingkungan
1. Bikin proyek + jalan kosong
2. Tema + struktur folder
3. Model data (Dart class)
4. Database SQLite  ← fondasi
5. Dashboard (inti)
6. Form tambah tugas global
7. Halaman Riwayat
8. Bottom navigation
9. Polish UI
10. Putuskan detail open
11. Tes + build APK
```

**Prinsip:** kerjain dari **data dulu (bawah)** baru **UI (atas)** — karena UI butuh data. Tiap tahap dites dulu sebelum lanjut biar pas error gampang ketahuan sumbernya.
