import 'package:anr/models/scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavoritesFilter extends StatelessWidget {
  const FavoritesFilter({super.key, this.enabled = true, this.initialValue, required this.onSelected});

  final bool enabled;
  final Scan? initialValue;
  final Function(Scan? scan) onSelected;

  @override
  Widget build(BuildContext context) {
    final i10n = AppLocalizations.of(context)!;

    return PopupMenuButton<Scan>(
      icon: initialValue is Scan ? const Icon(Icons.filter_alt_rounded) : const Icon(Icons.filter_alt_off_rounded),
      enabled: enabled,
      initialValue: initialValue,
      onSelected: onSelected,
      itemBuilder: (context) {
        return [
          PopupMenuItem(onTap: () => onSelected(null), child: Text(i10n.filterAll.toUpperCase())),
          ...Scan.values.map<PopupMenuEntry<Scan>>((scan) {
            return PopupMenuItem(value: scan, child: Text(scan.value.toUpperCase()));
          })
        ];
      },
    );
  }
}
