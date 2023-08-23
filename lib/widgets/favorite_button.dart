import 'package:anr/models/book_item.dart';
import 'package:anr/service_locator.dart';
import 'package:flutter/material.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({super.key, required this.bookItem});

  final BookItem bookItem;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool loading = true;
  bool isFavorite = false;

  Future<void> toggleFavorite() async {
    setState(() {
      loading = true;
      isFavorite = !isFavorite;
    });

    final success = await favoritesRepository.toggleFavorite(!isFavorite, widget.bookItem);

    setState(() {
      loading = false;
      isFavorite = success ? isFavorite : !isFavorite;
    });
  }

  @override
  void initState() {
    super.initState();

    favoritesRepository.isFavorite(widget.bookItem.slug).then((value) {
      setState(() {
        loading = false;
        isFavorite = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: loading ? null : toggleFavorite,
      icon: isFavorite ? const Icon(Icons.favorite_rounded) : const Icon(Icons.favorite_outline_rounded),
      color: isFavorite ? Colors.red : null,
    );
  }
}
