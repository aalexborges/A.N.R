import 'package:A.N.R/models/book.model.dart';
import 'package:A.N.R/models/book_data.model.dart';
import 'package:A.N.R/store/download.store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class DownloadAllButtonWidget extends StatelessWidget {
  final Book book;
  final BookData? bookData;

  const DownloadAllButtonWidget({
    required this.book,
    required this.bookData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<DownloadStore>(context);

    return Observer(builder: (context) {
      final chapters = bookData?.chapters ?? [];
      final disabled = store.chapters.length == chapters.length;

      return IconButton(
        icon: const Icon(Icons.download_rounded),
        onPressed: disabled
            ? null
            : () => store.addMany(book: book, bookData: bookData!),
      );
    });
  }
}
