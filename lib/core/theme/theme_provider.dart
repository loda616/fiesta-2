import 'package:flutter/material.dart';
import 'app_theme.dart';
import '../storage/local_storage.dart';


enum AppThemeMode {
  light,
  dark
}

class ThemeProvider extends ChangeNotifier {
  final LocalStorage localStorage;
  AppThemeMode _themeMode;

  ThemeProvider(this.localStorage) : _themeMode = AppThemeMode.dark {
    _loadTheme();
  }

  AppThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == AppThemeMode.dark;

  String get themeName => isDarkMode ? "Deep Navy & Neon" : "Cream Paper & Burgundy";

  ThemeData getTheme(BuildContext context) {
    switch (_themeMode) {
      case AppThemeMode.light:
        return AppTheme.lightTheme;
      case AppThemeMode.dark:
        return AppTheme.darkTheme;
    }
  }

  void _loadTheme() {
    final savedTheme = localStorage.getTheme();
    if (savedTheme != null) {
      _themeMode = AppThemeMode.values.firstWhere(
            (e) => e.toString() == savedTheme,
        orElse: () => AppThemeMode.dark,
      );
      notifyListeners();
    }
  }

  Future<void> setTheme(AppThemeMode mode) async {
    _themeMode = mode;
    await localStorage.saveTheme(mode.toString());
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    if (_themeMode == AppThemeMode.dark) {
      await setTheme(AppThemeMode.light);
    } else {
      await setTheme(AppThemeMode.dark);
    }
  }
}