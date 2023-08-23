import 'package:anr/widgets/dot_separator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookDataSubtitleInfos extends StatelessWidget {
  const BookDataSubtitleInfos({super.key, required this.scan, this.lastChapter, this.totalChapters, this.type});

  final String scan;

  final String? totalChapters;
  final String? lastChapter;
  final String? type;

  @override
  Widget build(BuildContext context) {
    final i10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.tertiary);

    return Container(
      height: 24,
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(bottom: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Text('${totalChapters ?? '?'}/${lastChapter ?? '?'}', style: textStyle),
            const DotSeparator(),
            Text(type ?? i10n.unknown.toUpperCase(), style: textStyle),
            const DotSeparator(),
            Text(scan, style: textStyle),
          ],
        ),
      ),
    );
  }
}
