// Import package Flutter untuk UI dan Material Design
import 'package:flutter/material.dart';

// Import file helper untuk operasi database
import 'database_helper.dart';
// Import model Note untuk struktur data catatan
import 'models/note.dart';
import 'splash_page.dart';

// Fungsi main adalah entry point aplikasi
void main() {
  // runApp() menjalankan aplikasi dengan widget MainApp sebagai root
  runApp(const MainApp());
}

// MainApp adalah widget root aplikasi (stateless karena tidak berubah)
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp: widget untuk setup aplikasi dengan Material Design
    return MaterialApp(
      // Sembunyikan banner debug di pojok kanan atas
      debugShowCheckedModeBanner: false,
      // Konfigurasi tema visual aplikasi
      theme: ThemeData(
        // Warna tema berdasarkan seed color BlueGrey
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        // Gunakan Material Design 3 untuk tampilan modern
        useMaterial3: true,
      ),
      // SplashPage menampilkan animasi singkat sebelum masuk ke NoteListPage
      home: const SplashPage(),
    );
  }
}

class NoteListPage extends StatefulWidget {
  const NoteListPage({super.key});

  @override
  State<NoteListPage> createState() => _NoteListPageState();
}

// _NoteListPageState adalah state dari NoteListPage yang mengelola data dan UI
class _NoteListPageState extends State<NoteListPage> {
  final _db = DatabaseHelper.instance;
  List<Note> _notes = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    setState(() => _isLoading = true);
    try {
      final data = await _db.getNotes();
      if (mounted) {
        setState(() {
          _notes = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal memuat data: $e')));
      }
    }
  }

  Future<void> _openForm({Note? note}) async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => NoteFormPage(note: note)),
    );
    if (updated == true) {
      _loadNotes();
    }
  }

  Future<void> _deleteNote(Note note) async {
    if (note.id == null) return;
    await _db.deleteNote(note.id!);
    _loadNotes();
  }

  String _formatDate(DateTime date) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${date.year}-${two(date.month)}-${two(date.day)} ${two(date.hour)}:${two(date.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catatan SQLite')),
      body: RefreshIndicator(
        onRefresh: _loadNotes,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _notes.isEmpty
            ? const Center(child: Text('Belum ada catatan.'))
            : ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _notes.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final note = _notes[index];
                  return ListTile(
                    title: Text(note.title),
                    subtitle: Text(
                      '${note.description}\n${_formatDate(note.createdAt)}',
                    ),
                    isThreeLine: true,
                    onTap: () => _openForm(note: note),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _openForm(note: note),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Hapus catatan?'),
                                  content: Text(
                                    '"${note.title}" akan dihapus.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('Batal'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text('Hapus'),
                                    ),
                                  ],
                                );
                              },
                            );
                            if (confirm == true) {
                              _deleteNote(note);
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }
}

// NoteFormPage adalah halaman form untuk tambah/edit catatan (stateful)
class NoteFormPage extends StatefulWidget {
  const NoteFormPage({super.key, this.note});

  // note: catatan yang akan diedit (null jika tambah baru)
  final Note? note;

  @override
  State<NoteFormPage> createState() => _NoteFormPageState();
}

// _NoteFormPageState adalah state untuk mengelola form input catatan
class _NoteFormPageState extends State<NoteFormPage> {
  // Controller untuk input field judul
  final _titleController = TextEditingController();
  // Controller untuk input field deskripsi/isi catatan
  final _descController = TextEditingController();
  // Instance database helper untuk menyimpan data
  final _db = DatabaseHelper.instance;
  // Flag untuk menandai apakah data sedang disimpan
  bool _isSaving = false;

  // initState dipanggil saat widget pertama kali dibuat
  @override
  void initState() {
    super.initState();
    // Jika ini adalah mode edit (note != null), isi form dengan data lama
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _descController.text = widget.note!.description;
    }
  }

  // dispose() dipanggil saat widget dihapus, digunakan untuk cleanup
  @override
  void dispose() {
    // Hapus controller untuk free memory
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  // Fungsi untuk menyimpan catatan baru atau update catatan yang ada
  Future<void> _saveNote() async {
    // Ambil input dari controller dan hapus whitespace
    final title = _titleController.text.trim();
    final desc = _descController.text.trim();
    // Validasi: judul dan deskripsi tidak boleh kosong
    if (title.isEmpty || desc.isEmpty) {
      // Tampilkan pesan error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul dan isi tidak boleh kosong.')),
      );
      return;
    }

    // Set flag menyimpan menjadi true (untuk disable tombol saat proses)
    setState(() => _isSaving = true);

    // Cek apakah ini mode tambah (widget.note == null) atau mode edit
    if (widget.note == null) {
      // Mode TAMBAH: buat catatan baru dengan waktu sekarang
      final newNote = Note(
        title: title,
        description: desc,
        createdAt: DateTime.now(),
      );
      // Simpan catatan baru ke database
      await _db.insertNote(newNote);
    } else {
      // Mode EDIT: update catatan yang sudah ada dengan data baru
      final updated = widget.note!.copyWith(title: title, description: desc);
      // Simpan perubahan ke database
      await _db.updateNote(updated);
    }

    // Setelah selesai, cek apakah widget masih mounted
    if (mounted) {
      // Stop loading indicator
      setState(() => _isSaving = false);
      // Kembali ke halaman sebelumnya dengan hasil true (data berhasil disimpan)
      Navigator.pop(context, true);
    }
  }

  @override
  // build() mengembalikan tampilan UI form input
  Widget build(BuildContext context) {
    // Tentukan apakah ini mode edit atau tambah
    final isEdit = widget.note != null;
    // Scaffold: struktur dasar halaman
    return Scaffold(
      // AppBar dengan judul dinamis ("Edit Catatan" atau "Tambah Catatan")
      appBar: AppBar(title: Text(isEdit ? 'Edit Catatan' : 'Tambah Catatan')),
      // body: konten form
      body: Padding(
        // Padding 16 unit di semua sisi
        padding: const EdgeInsets.all(16),
        // Column: layout vertikal untuk menampilkan input fields dan tombol
        child: Column(
          // Stretch children agar selebar parent
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input field judul catatan
            TextField(
              // Controller untuk mengakses value input
              controller: _titleController,
              // Dekorasi input field
              decoration: const InputDecoration(
                labelText: 'Judul',
                border: OutlineInputBorder(),
              ),
            ),
            // Spasi vertikal 12 unit
            const SizedBox(height: 12),
            // Input field deskripsi/isi catatan (multi-line)
            TextField(
              // Controller untuk mengakses value input
              controller: _descController,
              // Minimum 4 baris, maksimal 6 baris
              minLines: 4,
              maxLines: 6,
              // Dekorasi input field
              decoration: const InputDecoration(
                labelText: 'Isi Catatan',
                border: OutlineInputBorder(),
              ),
            ),
            // Spasi vertikal 20 unit sebelum tombol
            const SizedBox(height: 20),
            // Tombol untuk menyimpan catatan
            ElevatedButton.icon(
              // Disable tombol jika sedang menyimpan (null = disabled)
              onPressed: _isSaving ? null : _saveNote,
              icon: const Icon(Icons.save),
              // Text berubah saat sedang menyimpan
              label: Text(_isSaving ? 'Menyimpan...' : 'Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
