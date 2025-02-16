import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String themeKey = 'app_theme';
  final SharedPreferences _prefs;

  LocalStorage(this._prefs);

  Future<void> saveTheme(String theme) async {
    await _prefs.setString(themeKey, theme);
  }

  String? getTheme() {
    return _prefs.getString(themeKey);
  }
}
