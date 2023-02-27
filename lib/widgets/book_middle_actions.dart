import 'package:anr/models/book.dart';
import 'package:anr/models/book_data.dart';
import 'package:anr/widgets/chapters_title.dart';
import 'package:anr/widgets/details_button.dart';
import 'package:anr/widgets/read_button.dart';
import 'package:anr/widgets/shimmer_item.dart';
import 'package:flutter/material.dart';

class BookMiddleActions extends StatelessWidget {
  const BookMiddleActions({required this.book, super.key, this.data, this.onPressChangeOrder});

  final Book book;
  final BookData? data;
  final void Function()? onPressChangeOrder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: _shortSinopse(),
          ),
          DetailsButton(book: book, data: data),
          ReadButton(book: book, data: data),
          ChaptersTitle(onPressChangeOrder: onPressChangeOrder),
        ],
      ),
    );
  }

  Widget _shortSinopse() {
    if (data is BookData) {
      return Text(data!.sinopse.trim(), maxLines: 3, overflow: TextOverflow.ellipsis);
    }

    return const ShimmerItem(
      child: Card(
        margin: EdgeInsets.all(0),
        child: SizedBox(
          width: double.infinity,
          height: 60,
        ),
      ),
    );
  }
}
