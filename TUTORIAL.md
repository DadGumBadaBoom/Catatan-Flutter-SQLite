# Tutorial Menjalankan Aplikasi Catatan SQLite (Flutter)

Aplikasi sudah lengkap dan siap dijalankan. Ikuti langkah berikut di Windows.

## Prasyarat
- Flutter SDK sudah terpasang dan `flutter` ada di PATH.
- Android Studio + Android SDK + emulator, atau perangkat fisik dengan USB debugging.
- Versi Dart/Flutter minimal sesuai constraint di `pubspec.yaml` (Flutter 3.22+ sudah cukup).

## Langkah Menjalankan
1. Buka terminal di folder proyek ini: `lat_sqlite_flutter`.
2. Unduh dependency:
   ```bash
   flutter pub get
   ```
3. Jalankan aplikasi di emulator/perangkat yang aktif:
   ```bash
   flutter run
   ```
   - Jika ada lebih dari satu device, pilih dari daftar yang muncul.
4. Hot reload saat mengubah kode: tekan `r` di terminal (atau tombol petir di IDE).
5. Berhenti: `q` di terminal atau hentikan proses di IDE.

## Cara Pakai Aplikasi
- Halaman utama menampilkan daftar catatan.
- Tombol `Tambah` membuka form; isi judul dan isi, lalu `Simpan`.
- Tap item untuk mengedit; ubah lalu simpan.
- Ikon tempat sampah untuk menghapus (dengan konfirmasi).
- Tarik ke bawah pada daftar untuk refresh.

## Struktur Penting
- UI dan logika CRUD: `lib/main.dart`
- Helper database SQLite: `lib/database_helper.dart`
- Model data: `lib/models/note.dart`

## Troubleshooting Singkat
- Jika `flutter run` tidak menemukan device: pastikan emulator sedang berjalan atau perangkat terhubung dan terdeteksi `flutter devices`.
- Jika gagal `pub get`: cek koneksi internet atau jalur proxy; ulangi `flutter pub get`.
- Jika migrasi Android SDK: jalankan `flutter doctor` untuk melihat komponen yang kurang.
