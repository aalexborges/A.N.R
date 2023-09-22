import 'package:anr/models/details.dart';
import 'package:anr/models/scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key, required this.details});

  final Details details;

  @override
  Widget build(BuildContext context) {
    final i10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(details.name)),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              margin: const EdgeInsets.only(bottom: 8),
              child: Text(details.sinopse),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              title: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                margin: const EdgeInsets.only(bottom: 4),
                child: Text(i10n.dCategories),
              ),
              subtitle: SizedBox(
                height: 40,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  scrollDirection: Axis.horizontal,
                  itemCount: details.categories.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: Chip(label: Text(details.categories[index])),
                    );
                  },
                ),
              ),
            ),
            ListTile(
              title: Text(i10n.dName),
              subtitle: Text(details.name),
            ),
            ListTile(
              title: Text(i10n.dType),
              subtitle: Text((details.type ?? i10n.unknown).toUpperCase()),
            ),
            ListTile(
              title: Text(i10n.dAmountOfChapters),
              subtitle: Text(details.chapterLength.toString()),
            ),
            ListTile(
              title: Text(i10n.dLastChapterReleased),
              subtitle: Text(details.lastChapter),
            ),
            ListTile(
              title: Text(i10n.dScan),
              subtitle: Text(details.scan.value.toUpperCase()),
            ),
          ],
        ),
      ),
    );
  }
}
