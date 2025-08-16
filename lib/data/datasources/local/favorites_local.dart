import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class FavoritesLocal {
  static const _storageKey = 'favorites_v1';
  final SharedPreferences _prefs;

  FavoritesLocal(this._prefs);

  Future<Map<String, String>> _readAll() async {
    final raw = _prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return {};
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return decoded.map((k, v) => MapEntry(k, v as String));
  }

  Future<void> _writeAll(Map<String, String> map) async {
    await _prefs.setString(_storageKey, jsonEncode(map));
  }

  Future<void> put(String url, String articleJson) async {
    final all = await _readAll();
    all[url] = articleJson;
    await _writeAll(all);
  }

  Future<void> delete(String url) async {
    final all = await _readAll();
    all.remove(url);
    await _writeAll(all);
  }

  Future<Set<String>> ids() async {
    final all = await _readAll();
    return all.keys.toSet();
  }

  Future<List<String>> allJson() async {
    final all = await _readAll();
    return all.values.toList(growable: false);
  }

  Future<bool> exists(String url) async {
    final all = await _readAll();
    return all.containsKey(url);
  }
}
