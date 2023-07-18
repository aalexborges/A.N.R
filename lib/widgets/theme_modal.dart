import 'package:anr/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ThemeModal extends StatelessWidget {
  const ThemeModal({super.key});

  @override
  Widget build(BuildContext context) {
    final i10n = AppLocalizations.of(context)!;
    final currentThemeMode = themeService.getThemeMode();

    return Column(
      key: const Key('theme_modal'),
      mainAxisSize: MainAxisSize.min,
      children: ThemeMode.values
          .map<ListTile>((mode) {
            return ListTile(
              title: Text(getTitleByThemeMode(mode, i10n: i10n)),
              leading: Icon(getIconByThemeMode(mode)),
              selected: currentThemeMode == mode,
              onTap: () => Navigator.of(context).pop(mode),
            );
          })
          .toList()
          .reversed
          .toList(),
    );
  }

  String getTitleByThemeMode(ThemeMode mode, {required AppLocalizations i10n}) {
    if (mode == ThemeMode.dark) return i10n.darkThemeOption;
    if (mode == ThemeMode.light) return i10n.lightThemeOption;
    return i10n.systemThemeOption;
  }

  IconData getIconByThemeMode(ThemeMode mode) {
    if (mode == ThemeMode.dark) return Icons.dark_mode_rounded;
    if (mode == ThemeMode.light) return Icons.light_mode_rounded;
    return Icons.auto_awesome_rounded;
  }

  static Future<void> showModal(BuildContext context) async {
    final result = await showModalBottomSheet<ThemeMode>(context: context, builder: (ctx) => const ThemeModal());

    if (result is ThemeMode) themeService.changeTheme(result);
  }
}
