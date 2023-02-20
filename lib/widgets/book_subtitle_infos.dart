import 'package:anr/models/book.dart';
import 'package:anr/models/book_data.dart';
import 'package:anr/models/scan.dart';
import 'package:anr/widgets/shimmer_item.dart';
import 'package:flutter/material.dart';

class BookSubtitleInfos extends StatelessWidget {
  const BookSubtitleInfos({super.key, this.data, required this.book});

  final Book book;
  final BookData? data;

  static const height = 24.0;

  @override
  Widget build(BuildContext context) {
    const margin = EdgeInsets.only(top: 2, bottom: 8);

    if (data == null) {
      return ShimmerItem(
        child: Card(
          margin: margin,
          child: SizedBox(
            width: (56 * MediaQuery.of(context).size.width) / 100,
            height: height,
          ),
        ),
      );
    }

    final items = data!.subtitleInfos(book.type);

    return Container(
      height: height,
      margin: margin,
      alignment: Alignment.centerLeft,
      child: ListView.separated(
        itemCount: items.length + 1,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => const BookSubtitleInfosDot(),
        itemBuilder: (context, index) {
          if (index == items.length) return _text(context, book.scan.value.toUpperCase());
          return _text(context, items[index]);
        },
      ),
    );
  }

  Widget _text(BuildContext context, String value) {
    final theme = Theme.of(context);

    return Center(
      child: Text(
        value,
        style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.tertiary),
      ),
    );
  }
}

class BookSubtitleInfosDot extends StatelessWidget {
  const BookSubtitleInfosDot({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 6,
        height: 6,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
