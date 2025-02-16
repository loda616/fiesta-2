import 'package:flutter/material.dart';
import 'app_theme.dart';
import '../storage/local_storage.dart';

enum AppThemeMode {
  lightGrey,
  lightPurple,
  darkGrey,
}

class ThemeProvider extends ChangeNotifier {
  final LocalStorage localStorage;
  AppThemeMode _themeMode;

  ThemeProvider(this.localStorage) : _themeMode = AppThemeMode.lightGrey {
    _loadTheme();
  }

  AppThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == AppThemeMode.darkGrey;

  ThemeData getTheme(BuildContext context) {
    switch (_themeMode) {
      case AppThemeMode.lightGrey:
        return AppTheme.lightGreyTheme;
      case AppThemeMode.lightPurple:
        return AppTheme.lightPurpleTheme;
      case AppThemeMode.darkGrey:
        return AppTheme.darkGreyTheme;
    }
  }

  void _loadTheme() {
    final savedTheme = localStorage.getTheme();
    if (savedTheme != null) {
      _themeMode = AppThemeMode.values.firstWhere(
            (e) => e.toString() == savedTheme,
        orElse: () => AppThemeMode.lightGrey,
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
    if (_themeMode == AppThemeMode.lightGrey) {
      await setTheme(AppThemeMode.darkGrey);
    } else if (_themeMode == AppThemeMode.darkGrey) {
      await setTheme(AppThemeMode.lightPurple);
    } else {
      await setTheme(AppThemeMode.lightGrey);
    }
  }

  Future<void> cycleTheme() async {
    switch (_themeMode) {
      case AppThemeMode.lightGrey:
        await setTheme(AppThemeMode.darkGrey);
        break;
      case AppThemeMode.darkGrey:
        await setTheme(AppThemeMode.lightPurple);
        break;
      case AppThemeMode.lightPurple:
        await setTheme(AppThemeMode.lightGrey);
        break;
    }
  }
}