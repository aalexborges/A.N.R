import 'package:A.N.R/constants/routes_path.dart';
import 'package:A.N.R/constants/scans.dart';
import 'package:A.N.R/store/favorites.store.dart';
import 'package:A.N.R/widgets/book.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../constants/grid_book_delegate.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<FavoritesStore>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
        actions: [
          Observer(builder: (context) {
            return PopupMenuButton<Scans>(
              icon: store.filterBy == null
                  ? const Icon(Icons.filter_alt_off_rounded)
                  : const Icon(Icons.filter_alt_rounded),
              initialValue: store.filterBy,
              onSelected: store.changeFilter,
              itemBuilder: (context) => <PopupMenuEntry<Scans>>[
                PopupMenuItem(
                  onTap: () => store.changeFilter(null),
                  child: const Text('Todos'),
                ),
                ...Scans.values.map((e) {
                  return PopupMenuItem(value: e, child: Text(e.value));
                }).toList(),
              ],
            );
          }),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: store.getAll,
        child: Observer(builder: (context) {
          return GridView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            itemCount: store.filteredFavorites.length,
            gridDelegate: gridBookDelegate,
            itemBuilder: (context, index) {
              final book = store.filteredFavorites[index];

              return BookWidget(
                book: book,
                onTap: () => context.push(RoutesPath.BOOK, extra: book),
              );
            },
          );
        }),
      ),
    );
  }
}
