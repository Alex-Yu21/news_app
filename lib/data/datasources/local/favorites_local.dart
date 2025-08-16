import 'package:shared_preferences/shared_preferences.dart';

class FavoritesLocal {
  FavoritesLocal(this._prefs);
  final SharedPreferences _prefs;

  static const _idsKey = 'favorites_ids';

  Future<void> put(String id, String json) async {
    final ids = _prefs.getStringList(_idsKey) ?? <String>[];
    if (!ids.contains(id)) {
      await _prefs.setStringList(_idsKey, [...ids, id]);
    }
    await _prefs.setString(id, json);
  }

  Future<void> delete(String id) async {
    final ids = _prefs.getStringList(_idsKey) ?? <String>[];
    await _prefs.remove(id);
    await _prefs.setStringList(
      _idsKey,
      ids.where((e) => e != id).toList(growable: false),
    );
  }

  Future<List<String>> allJson() async {
    final ids = _prefs.getStringList(_idsKey) ?? <String>[];
    return ids
        .map((id) => _prefs.getString(id))
        .whereType<String>()
        .toList(growable: false);
  }

  Future<Set<String>> ids() async {
    final ids = _prefs.getStringList(_idsKey) ?? <String>[];
    return ids.toSet();
  }

  Future<bool> exists(String id) async {
    final ids = _prefs.getStringList(_idsKey) ?? <String>[];
    return ids.contains(id);
  }
}
