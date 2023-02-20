import 'package:anr/models/book.dart';
import 'package:anr/models/scan.dart';
import 'package:anr/router.dart';
import 'package:anr/widgets/shimmer_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BookListElement extends StatelessWidget {
  const BookListElement({super.key, this.margin, required this.book});

  final Book book;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Card(
        color: Theme.of(context).colorScheme.surfaceVariant,
        elevation: 0,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        semanticContainer: true,
        child: SizedBox(
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
                  httpHeaders: book.scan.repository.headers,
                  maxWidthDiskCache: BookListElementSize.cacheMaxWidth,
                  maxHeightDiskCache: BookListElementSize.cacheMaxHeight,
                  placeholder: (context, url) => const BookListElementShimmer(),
                ),
              ),
              Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BookListElementFloatItem(
                      hidden: book.type == null,
                      child: FittedBox(
                        child: Text(
                          book.type.toString().trim().toUpperCase(),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(onTap: () => context.push(ScreenPaths.book, extra: book)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BookListElementFloatItem extends StatelessWidget {
  const BookListElementFloatItem({super.key, this.child, this.padding, this.hidden = false});

  final bool hidden;
  final Widget? child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    if (hidden) return const SizedBox();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
      child: Padding(padding: padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4), child: child),
    );
  }
}

class BookListElementShimmer extends StatelessWidget {
  const BookListElementShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShimmerItem(
      child: Card(
        child: SizedBox(
          width: BookListElementSize.width,
          height: BookListElementSize.height,
        ),
      ),
    );
  }
}

abstract class BookListElementSize {
  static const width = 112.0;
  static const height = 158.0;

  static const size = Size(width, height);

  static const cacheMaxWidth = 324;
  static const cacheMaxHeight = 464;

  static const sliverGridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
    childAspectRatio: 0.72,
    maxCrossAxisExtent: height,
  );
}
