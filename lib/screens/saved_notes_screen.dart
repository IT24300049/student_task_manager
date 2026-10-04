import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/local_storage_service.dart';

class SavedNotesScreen extends StatefulWidget {
  const SavedNotesScreen({super.key});

  @override
  State<SavedNotesScreen> createState() => _SavedNotesScreenState();
}

class _SavedNotesScreenState extends State<SavedNotesScreen> {
  Note? _savedNote;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNote();
  }

  Future<void> _loadNote() async {
    setState(() {
      _isLoading = true;
    });
    final note = await LocalStorageService().loadNote();
    setState(() {
      _savedNote = note;
      _isLoading = false;
    });
  }

  Future<void> _deleteNote() async {
    await LocalStorageService().clearNote();
    await _loadNote();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Note deleted from local storage'),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Local Data'),
        actions: [
          if (_savedNote != null)
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: 'Delete Note',
              onPressed: _deleteNote,
            ),
        ],
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_savedNote == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.note_alt_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              'No saved data found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _savedNote!.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Chip(
                    label: Text(_savedNote!.category),
                    backgroundColor: Colors.blue.shade50,
                  ),
                ],
              ),
              const Divider(height: 24),
              const Text(
                'Description:',
                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black54),
              ),
              const SizedBox(height: 4),
              Text(
                _savedNote!.description,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}