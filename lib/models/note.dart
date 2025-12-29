// Model Note merepresentasikan struktur data catatan
class Note {
  final int? id; // ID unik catatan (nullable, null saat create)
  final String title; // Judul catatan
  final String description; // Isi/deskripsi catatan
  final DateTime createdAt; // Waktu pembuatan catatan

  // Constructor untuk membuat instance Note
  const Note({
    this.id, // Optional: biasanya null saat create baru
    required this.title, // Required: harus diisi
    required this.description, // Required: harus diisi
    required this.createdAt, // Required: harus diisi
  });

  // Method copyWith: membuat copy Note dengan field tertentu yang berbeda
  // Berguna untuk update hanya beberapa field tanpa mengubah yang lain
  Note copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? createdAt,
  }) {
    return Note(
      // Gunakan nilai baru jika ada, else gunakan nilai lama (??)
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Method toMap: konversi Note object menjadi Map untuk database
  // Format key harus sesuai dengan column name di database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'created_at': createdAt
          .toIso8601String(), // Convert DateTime ke ISO8601 string
    };
  }

  // Factory constructor: membuat Note dari Map (hasil query database)
  // Named constructor bernama 'fromMap' untuk deserialisasi data
  factory Note.fromMap(Map<String, dynamic> map) {
    // Helper function: parse created_at yang bisa string atau integer
    // Database kadang menyimpan DateTime berbeda-beda (String ISO8601 atau int ms)
    DateTime parseCreatedAt(dynamic value) {
      // Jika value adalah integer, convert dari milliseconds since epoch
      if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
      // Jika value adalah string, parse sebagai ISO8601 datetime
      if (value is String) {
        final parsed = DateTime.tryParse(value);
        if (parsed != null) return parsed;
      }
      // Fallback: jika tidak bisa parse, gunakan waktu sekarang
      return DateTime.now();
    }

    // Buat Note object dari map dengan type casting yang aman
    return Note(
      id: map['id'] as int?,
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      createdAt: parseCreatedAt(map['created_at']),
    );
  }
}
