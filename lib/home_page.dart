import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Box noteBox;

  @override
  void initState() {
    super.initState();
    noteBox = Hive.box('notesBox');
  }

  void _showNoteDialog({Map? note, dynamic key}) {
    final titleController = TextEditingController(text: note?['title'] ?? '');
    final contentController = TextEditingController(text: note?['content'] ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(key == null ? 'Yeni Not' : 'Notu Düzenle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Başlık',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: contentController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'İçerik',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            FilledButton(
              onPressed: () async {
                final title = titleController.text.trim();
                final content = contentController.text.trim();

                if (title.isEmpty && content.isEmpty) return;

                final noteData = {
                  'title': title,
                  'content': content,
                  'updatedAt': DateTime.now().toString(),
                };

                if (key == null) {
                  await noteBox.add(noteData);
                } else {
                  await noteBox.put(key, noteData);
                }

                if (mounted) Navigator.pop(context);
              },
              child: const Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Not Defterim'),
      ),
      body: const Center(
        child: Text('Sayfa Gövdesi'),
      ),
    );
  }
}