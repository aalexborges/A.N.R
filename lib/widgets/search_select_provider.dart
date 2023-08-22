import 'package:anr/models/scan.dart';
import 'package:flutter/material.dart';

class SearchSelectProvider extends StatelessWidget {
  const SearchSelectProvider({super.key, required this.initialValue, required this.onSelected, this.enabled = true});

  final bool enabled;
  final Scan initialValue;
  final Function(Scan scan) onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Scan>(
      enabled: enabled,
      initialValue: initialValue,
      onSelected: onSelected,
      itemBuilder: (context) {
        return Scan.values.map<PopupMenuEntry<Scan>>((scan) {
          return PopupMenuItem(value: scan, child: Text(scan.value.toUpperCase()));
        }).toList();
      },
    );
  }
}
