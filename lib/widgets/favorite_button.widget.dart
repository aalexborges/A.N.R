import 'package:A.N.R/models/book.model.dart';
import 'package:A.N.R/store/favorites.store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class FavoriteButtonWidget extends StatelessWidget {
  final Book book;

  const FavoriteButtonWidget(this.book, {super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<FavoritesStore>(context);

    return Observer(builder: (context) {
      final isFavorite = store.favorites.containsKey(book.id);

      return IconButton(
        icon: Icon(
          isFavorite ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
          color: isFavorite ? Colors.red : null,
        ),
        onPressed: () async {
          try {
            if (isFavorite) return store.remove(book.id);
            await store.add(book);
          } catch (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error.toString())),
            );
          }
        },
      );
    });
  }
}
