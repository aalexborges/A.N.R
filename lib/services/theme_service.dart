import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends ChangeNotifier {
  final SharedPreferences _prefs;

  ThemeService(this._prefs);

  ThemeMode getThemeMode() {
    final theme = _prefs.getString('theme');

    if (theme == 'dark') return ThemeMode.dark;
    if (theme == 'light') return ThemeMode.light;

    return ThemeMode.system;
  }

  Future<void> changeTheme(ThemeMode theme) async {
    notifyListeners();

    await _prefs.setString('theme', theme.toString());
  }
}
