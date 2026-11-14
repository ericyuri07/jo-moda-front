import 'package:shared_preferences/shared_preferences.dart';

/// Guarda o token do Sanctum no aparelho para manter o login entre aberturas.
class TokenStorage {
  static const String _key = 'auth_token';

  String? _cached;
  bool _loaded = false;

  Future<String?> read() async {
    if (!_loaded) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      _cached = prefs.getString(_key);
      _loaded = true;
    }
    return _cached;
  }

  Future<void> save(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, token);
    _cached = token;
    _loaded = true;
  }

  Future<void> clear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    _cached = null;
    _loaded = true;
  }
}
