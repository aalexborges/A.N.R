import 'package:anr/models/book.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BookListElement extends StatelessWidget {
  const BookListElement({super.key, this.margin, required this.book});

  final Book book;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          color: Theme.of(context).colorScheme.secondary,
          width: BookListElementSize.width,
          height: BookListElementSize.height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  cacheKey: book.slug,
                  imageUrl: book.src,
                  maxWidthDiskCache: BookListElementSize.cacheMaxWidth,
                  maxHeightDiskCache: BookListElementSize.cacheMaxHeight,
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BookListElementFloatItem(
                        hidden: book.type == null,
                        child: Text(
                          book.type.toString().trim().toUpperCase(),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                          maxLines: 1,
                        ),
                      ),
                      BookListElementFloatItem(
                        padding: const EdgeInsets.all(4),
                        borderRadius: BorderRadius.circular(100),
                        child: Icon(Icons.favorite, size: 20, color: Colors.red.withOpacity(0.8)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BookListElementFloatItem extends StatelessWidget {
  const BookListElementFloatItem({super.key, this.child, this.padding, this.borderRadius, this.hidden = false});

  final bool hidden;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    if (hidden) return const SizedBox();

    return Container(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      constraints: const BoxConstraints(maxWidth: BookListElementSize.width - 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.72),
        borderRadius: borderRadius ?? BorderRadius.circular(6),
      ),
      child: FittedBox(child: child),
    );
  }
}

abstract class BookListElementSize {
  static const width = 112.0;
  static const height = 158.0;

  static const size = Size(width, height);

  static const cacheMaxWidth = 180;
  static const cacheMaxHeight = 254;
}
