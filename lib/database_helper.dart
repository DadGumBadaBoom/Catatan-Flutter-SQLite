// Import untuk path manipulation
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'models/note.dart';

// DatabaseHelper adalah singleton class untuk mengelola semua operasi database
class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, 'notes.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            created_at TEXT NOT NULL
          )
        ''');

        final now = DateTime.now().toIso8601String();
        await db.insert('notes', {
          'title': 'Contoh Catatan 1',
          'description':
              'Halo! Ini data contoh yang bisa kamu edit atau hapus.',
          'created_at': now,
        });
        await db.insert('notes', {
          'title': 'Tips',
          'description': 'Beberapa tips singkat untuk memulai aplikasi ini.',
          'created_at': now,
        });
      },
    );
  }

  // Insert note dan kembalikan id yang dihasilkan
  Future<int> insertNote(Note note) async {
    final db = await database;
    return await db.insert('notes', note.toMap());
  }

  // Ambil semua notes, urutkan dari terbaru
  Future<List<Note>> getNotes() async {
    final db = await database;
    final maps = await db.query('notes', orderBy: 'id DESC');
    return maps.map((m) => Note.fromMap(m)).toList();
  }

  // Update note berdasarkan id
  Future<int> updateNote(Note note) async {
    final db = await database;
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  // Hapus note berdasarkan id
  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}
