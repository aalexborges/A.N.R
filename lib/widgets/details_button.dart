import 'package:anr/models/book.dart';
import 'package:anr/models/book_data.dart';
import 'package:anr/models/details.dart';
import 'package:anr/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class DetailsButton extends StatelessWidget {
  const DetailsButton({super.key, this.data, required this.book});

  final Book book;
  final BookData? data;

  void _onPressed(BuildContext context) {
    context.push(
      ScreenPaths.details,
      extra: Details.fromBook(book: book, data: data!),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return TextButton(
      onPressed: data is BookData ? (() => _onPressed(context)) : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(t.bookDetails.toUpperCase()),
          Container(
            margin: const EdgeInsets.only(left: 8),
            child: _icon(data == null),
          )
        ],
      ),
    );
  }

  Widget _icon(bool isLoading) {
    if (!isLoading) return const Icon(Icons.arrow_forward_rounded, size: 20);

    return const SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(strokeWidth: 2),
    );
  }
}
