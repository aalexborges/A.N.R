import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ThemeRepository extends ChangeNotifier {
  static const prefKey = 'theme';

  ThemeRepository(this._prefs) {
    final prefTheme = _prefs.getString(prefKey);

    _currentTheme = prefTheme != null ? _getThemeByValue(prefTheme) : ThemeMode.system;
  }

  final SharedPreferences _prefs;
  late ThemeMode _currentTheme;

  ThemeMode get currentTheme => _currentTheme;

  IconData get icon => ThemeOption.iconByTheme(_currentTheme);

  Future<void> setTheme(ThemeMode theme) async {
    _currentTheme = theme;

    notifyListeners();

    await _prefs.setString(prefKey, theme.name);
  }

  Future<void> selectThemeModal(BuildContext context) async {
    final t = AppLocalizations.of(context)!;

    final selectedTheme = await showModalBottomSheet<ThemeMode?>(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: ThemeMode.values.map((e) {
            final option = ThemeOption(t: t, theme: e);

            return ListTile(
              title: Text(option.text),
              leading: Icon(option.icon),
              onTap: () => Navigator.of(context).pop(e),
            );
          }).toList(),
        );
      },
    );

    if (selectedTheme != null) setTheme(selectedTheme);
  }

  ThemeMode _getThemeByValue(String? value) {
    if (value == null) return ThemeMode.system;

    final results = ThemeMode.values.where((element) => element.name == value);
    return results.isEmpty ? ThemeMode.system : results.first;
  }
}

class ThemeOption {
  const ThemeOption({required this.t, required this.theme});

  final ThemeMode theme;
  final AppLocalizations t;

  IconData get icon => iconByTheme(theme);

  String get text {
    switch (theme) {
      case ThemeMode.dark:
        return t.darkTheme;

      case ThemeMode.light:
        return t.lightTheme;

      case ThemeMode.system:
        return t.systemTheme;
    }
  }

  static iconByTheme(ThemeMode theme) {
    switch (theme) {
      case ThemeMode.dark:
        return Icons.dark_mode_rounded;

      case ThemeMode.light:
        return Icons.light_mode_rounded;

      case ThemeMode.system:
        return Icons.auto_awesome_rounded;
    }
  }
}
