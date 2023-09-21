import 'package:anr/models/book.dart';
import 'package:anr/models/scan.dart';
import 'package:anr/widgets/book_list_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BookImageBackground extends StatelessWidget {
  const BookImageBackground({super.key, required this.book, required this.child});

  final Book book;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            cacheKey: book.slug,
            imageUrl: book.src,
            httpHeaders: book.scan.repository.headers,
            maxWidthDiskCache: BookListItemSize.cacheMaxWidth,
            maxHeightDiskCache: BookListItemSize.cacheMaxHeight,
            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
          ),
        ),
        Positioned.fill(
          top: 0,
          bottom: -1,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0, 0.5, 0.95],
                colors: [
                  Theme.of(context).colorScheme.background,
                  Colors.transparent,
                  Theme.of(context).colorScheme.background,
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                child,
              ],
            ),
          ),
        )
      ],
    );
  }
}
