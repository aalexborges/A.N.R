import 'package:anr/models/book_item.dart';
import 'package:anr/models/scan.dart';
import 'package:anr/service_locator.dart';
import 'package:anr/widgets/book_item_button.dart';
import 'package:anr/widgets/favorites_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  bool loading = true;
  List<BookItem> favorites = [];
  Scan? filterBy;

  Future<void> loadFavorites({Scan? scan, bool refresh = false}) async {
    final items = await favoritesRepository.get(scan: scan, forceUpdate: refresh);

    setState(() {
      favorites = items;
      filterBy = scan;
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final i10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(i10n.favorites),
        actions: [
          FavoritesFilter(
            enabled: !loading,
            initialValue: filterBy,
            onSelected: (scan) => loadFavorites(scan: scan),
          ),
        ],
      ),
      body: body(i10n),
    );
  }

  Widget body(AppLocalizations i10n) {
    if (loading) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    if (favorites.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(children: [
            Text(filterBy is Scan ? i10n.noFavoritesByScan(filterBy!) : i10n.noFavorites),
            ElevatedButton(
              onPressed: () => loadFavorites(scan: filterBy, refresh: true),
              child: Text(i10n.refresh),
            ),
          ]),
        ),
      );
    }

    return RefreshIndicator.adaptive(
      key: const Key('favorites-grid-list-refresh'),
      onRefresh: () => loadFavorites(refresh: true),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          key: const Key('favorites-grid-list'),
          gridDelegate: BookItemButtonSizes.sliverGridDelegate,
          physics: const BouncingScrollPhysics(),
          itemCount: favorites.length,
          itemBuilder: (context, index) => BookItemButton(bookItem: favorites[index]),
        ),
      ),
    );
  }
}
