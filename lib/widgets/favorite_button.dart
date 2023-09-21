import 'package:anr/models/book.dart';
import 'package:anr/service_locator.dart';
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
    setState(() {
      _isFavorite = !_isFavorite;
      _isLoading = true;
    });

    final success = await favoritesRepository.toggleFavorite(!_isFavorite, widget.book);
    if (!success) _showSnackBarError();

    setState(() {
      _isLoading = false;
      _isFavorite = success ? _isFavorite : !_isFavorite;
    });
  }

  @override
  void initState() {
    super.initState();

    favoritesRepository.isFavorite(widget.book.slug).then((value) {
      setState(() {
        _isLoading = false;
        _isFavorite = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _isLoading ? null : _onPressed,
      icon: Icon(_isFavorite ? Icons.favorite_rounded : Icons.favorite_outline_rounded),
      color: _isFavorite ? Colors.red : null,
    );
  }

  void _showSnackBarError() {
    final i10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);

    messenger.clearSnackBars();
    messenger.showSnackBar(SnackBar(content: Text(i10n.toggleFavoriteError)));

    messenger.clearSnackBars();
    messenger.showSnackBar(SnackBar(content: Text(i10n.toggleFavoriteError)));
  }
}
