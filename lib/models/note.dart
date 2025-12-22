class Note {
  final int? id;
  final String title;
  final String description;
  final DateTime createdAt;

  const Note({
    this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  Note copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? createdAt,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    // created_at bisa tersimpan sebagai String ISO8601 atau integer (msSinceEpoch)
    DateTime parseCreatedAt(dynamic value) {
      if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
      if (value is String) {
        final parsed = DateTime.tryParse(value);
        if (parsed != null) return parsed;
      }
      return DateTime.now();
    }

    return Note(
      id: map['id'] as int?,
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      createdAt: parseCreatedAt(map['created_at']),
    );
  }
}
