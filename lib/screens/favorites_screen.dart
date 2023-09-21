import 'dart:async';

import 'package:anr/models/scan.dart';
import 'package:anr/stores/favorites_store.dart';
import 'package:anr/widgets/book_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late FavoritesStore _store;

  @override
  void initState() {
    _store = FavoritesStore()..get().catchError(_snackBarError);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.favorites),
        actions: [
          Observer(builder: (context) {
            return PopupMenuButton<Scan>(
              icon: _store.filterBy == null
                  ? const Icon(Icons.filter_alt_off_rounded)
                  : const Icon(Icons.filter_alt_rounded),
              enabled: !_store.isLoading,
              initialValue: _store.filterBy,
              onSelected: _store.changeFilter,
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    onTap: () => _store.changeFilter(null),
                    child: Text(t.all.toUpperCase()),
                  ),
                  ...Scan.values.map<PopupMenuEntry<Scan>>((scan) {
                    return PopupMenuItem(value: scan, child: Text(scan.value.toUpperCase()));
                  }).toList(),
                ];
              },
            );
          }),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _store.get,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Observer(builder: (context) {
            if (_store.isLoading) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }

            if (_store.favorites.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Center(
                  child: Text(
                    _store.filterBy is Scan ? t.noFavoritesByScan(_store.filterBy!.value.toUpperCase()) : t.noFavorites,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            return GridView.builder(
              gridDelegate: BookListItemSize.sliverGridDelegate,
              itemCount: _store.favorites.length,
              itemBuilder: (context, index) => BookListItem(book: _store.favorites[index]),
            );
          }),
        ),
      ),
    );
  }

  FutureOr<void> _snackBarError(dynamic e) {
    final t = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);

    messenger.clearSnackBars();
    messenger.showSnackBar(SnackBar(content: Text(t.getFavoritesError)));
  }
}
