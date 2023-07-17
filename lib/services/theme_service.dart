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

  IconData getIcon() {
    final theme = getThemeMode();

    if (theme == ThemeMode.dark) return Icons.dark_mode_rounded;
    if (theme == ThemeMode.light) return Icons.light_mode_rounded;
    return Icons.auto_awesome_rounded;
  }

  Future<void> changeTheme(ThemeMode theme) async {
    await _prefs.setString('theme', theme.name);
    notifyListeners();
  }
}
