# lat_sqlite_flutter

Aplikasi contoh Flutter untuk demonstrasi penggunaan SQLite lokal menggunakan paket `sqflite`.

Deskripsi
---------

Proyek ini menunjukkan implementasi CRUD sederhana (Create, Read, Update, Delete) untuk catatan (notes) yang disimpan di database SQLite lokal. Cocok sebagai referensi latihan pemrograman mobile menggunakan Flutter.

Fitur
------

- Menambah, melihat, mengedit, dan menghapus catatan
- Penyimpanan lokal menggunakan `sqflite`
- Struktur kode sederhana: `main.dart`, `database_helper.dart`, dan model `Note`

Prasyarat
---------

- Flutter SDK (stable) terpasang
- Android Studio / Xcode atau perangkat fisik/emulator untuk menjalankan aplikasi

Instalasi
---------

1. Clone repositori ini:

```bash
git clone <url-repo-anda>
cd lat_sqlite_flutter
```

2. Ambil dependensi:

```bash
flutter pub get
```

Menjalankan aplikasi
---------------------

Menjalankan di perangkat terhubung atau emulator:

```bash
flutter run
```

Jika ingin menjalankan pada target tertentu (mis. Android):

```bash
flutter run -d android
```

Struktur Proyek (ringkasan)
---------------------------

- `lib/main.dart` : Entry point aplikasi
- `lib/database_helper.dart` : Kelas pembantu untuk operasi SQLite (open DB, CRUD)
- `lib/models/note.dart` : Model data `Note`

Database
--------

Proyek ini menggunakan paket `sqflite` untuk akses SQLite. Database dibuat dan dikelola melalui `DatabaseHelper` (lihat `lib/database_helper.dart`). Untuk mereset database selama pengembangan, hapus file database pada storage aplikasi atau ganti versi/logic pada helper.

Kontribusi
----------

Silakan ajukan pull request untuk perbaikan atau fitur baru. Untuk perubahan besar, buka issue terlebih dahulu agar pembahasan bisa dilakukan.

Lisensi
-------

Proyek ini diserahkan tanpa lisensi khusus. Tambahkan file `LICENSE` jika ingin menetapkan lisensi.

Kontak
-------

Jika ada pertanyaan, beri tahu melalui issue pada repositori.
