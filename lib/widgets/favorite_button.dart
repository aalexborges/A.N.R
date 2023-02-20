import 'package:anr/models/book.dart';
import 'package:anr/repositories/favorites_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({super.key, required this.book});

  final Book book;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool _isLoading = true;
  bool _isFavorite = false;

  Future<void> _onPressed() async {
    final newFavoriteState = !_isFavorite;

    setState(() {
      _isFavorite = newFavoriteState;
      _isLoading = true;
    });

    FavoritesRepository.I
        .setFavorite(book: widget.book, remove: !newFavoriteState)
        .then((value) => setState(() => _isLoading = false))
        .catchError((error) => _snackBarError(!newFavoriteState));
  }

  @override
  void initState() {
    FavoritesRepository.I.isFavorite(widget.book.slug).then((value) {
      setState(() {
        _isLoading = false;
        _isFavorite = value;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _isLoading ? null : _onPressed,
      icon: Icon(_isFavorite ? Icons.favorite_rounded : Icons.favorite_outline_rounded),
      color: _isFavorite ? Colors.red : null,
    );
  }

  void _snackBarError(bool favoriteState) {
    setState(() {
      _isFavorite = favoriteState;
      _isLoading = false;
    });

    final t = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);

    messenger.clearSnackBars();
    messenger.showSnackBar(SnackBar(content: Text(t.toggleFavoriteError)));
  }
}
