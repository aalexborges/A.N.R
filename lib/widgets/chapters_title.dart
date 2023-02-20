import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChaptersTitle extends StatelessWidget {
  const ChaptersTitle({super.key, this.onPressChangeOrder});

  final void Function()? onPressChangeOrder;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            t.chapters,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Row(
            children: [
              IconButton(
                onPressed: onPressChangeOrder,
                icon: const Icon(Icons.sort_by_alpha_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
