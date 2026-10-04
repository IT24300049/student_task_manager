import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';

class LocalStorageService {
  static const String _noteKey = 'saved_note';

  Future<void> saveNote(Note note) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final String jsonValue = jsonEncode(note.toJson());
    await preferences.setString(_noteKey, jsonValue);
  }

  Future<Note?> loadNote() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? jsonValue = preferences.getString(_noteKey);
    if (jsonValue == null) {
      return null;
    }
    return Note.fromJson(jsonDecode(jsonValue));
  }

  Future<void> clearNote() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(_noteKey);
  }
}