import 'package:anr/models/book.dart';
import 'package:anr/models/scan.dart';
import 'package:anr/router.dart';
import 'package:anr/widgets/book_item_float_type.dart';
import 'package:anr/widgets/shimmer_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BookListItem extends StatelessWidget {
  const BookListItem({super.key, this.book});

  final Book? book;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceVariant,
      elevation: 0,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      semanticContainer: true,
      child: SizedBox(
        width: BookListItemSize.width,
        height: BookListItemSize.height,
        child: _content(context),
      ),
    );
  }

  Widget _content(BuildContext context) {
    if (book is! Book) {
      return const ShimmerItem(
        child: Card(
          margin: EdgeInsets.all(0),
          child: SizedBox(
            width: BookListItemSize.width,
            height: BookListItemSize.height,
          ),
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            cacheKey: book!.slug,
            imageUrl: book!.src,
            httpHeaders: book!.scan.repository.headers,
            maxWidthDiskCache: BookListItemSize.cacheMaxWidth,
            maxHeightDiskCache: BookListItemSize.cacheMaxHeight,
            errorWidget: (context, url, error) => const Center(child: Icon(Icons.broken_image_rounded)),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            width: BookListItemSize.width,
            alignment: Alignment.topLeft,
            child: BookItemFloatType(type: book!.type?.toString().trim().toUpperCase()),
          ),
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(onTap: () => context.push(ScreenPaths.book, extra: book)),
          ),
        ),
      ],
    );
  }
}

abstract class BookListItemSize {
  static const width = 112.0;
  static const height = 158.0;

  static const size = Size(width, height);

  static const cacheMaxWidth = 324;
  static const cacheMaxHeight = 464;

  static const sliverGridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
    childAspectRatio: 0.72,
    maxCrossAxisExtent: height,
  );

  // ignore: prefer_void_to_null
  static List<Null> loadingItems(BuildContext context) {
    final length = (MediaQuery.of(context).size.width / width).ceil();
    return List.filled(length, null);
  }
}
