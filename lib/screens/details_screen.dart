import 'package:anr/models/book_data.dart';
import 'package:anr/models/scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key, required this.bookData});

  final BookData bookData;

  @override
  Widget build(BuildContext context) {
    final i10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(bookData.bookItem.name)),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              margin: const EdgeInsets.only(bottom: 8),
              child: Text(bookData.sinopse),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              title: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                margin: const EdgeInsets.only(bottom: 4),
                child: Text(i10n.detailsTileCategories),
              ),
              subtitle: SizedBox(
                height: 40,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  scrollDirection: Axis.horizontal,
                  itemCount: bookData.categories.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: Chip(label: Text(bookData.categories[index])),
                    );
                  },
                ),
              ),
            ),
            ListTile(
              title: Text(i10n.detailsTileName),
              subtitle: Text(bookData.bookItem.name),
            ),
            ListTile(
              title: Text(i10n.detailsTileType),
              subtitle: Text((bookData.type ?? bookData.bookItem.type ?? i10n.unknown).toUpperCase()),
            ),
            ListTile(
              title: Text(i10n.detailsTileScan),
              subtitle: Text(bookData.bookItem.scan.value.toUpperCase()),
            ),
          ],
        ),
      ),
    );
  }
}
