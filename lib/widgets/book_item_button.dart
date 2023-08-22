import 'package:anr/models/book_item.dart';
import 'package:anr/models/scan.dart';
import 'package:anr/utils/route_paths.dart';
import 'package:anr/widgets/book_item_float_type.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class BookItemButton extends StatelessWidget {
  const BookItemButton({super.key, this.bookItem});

  final BookItem? bookItem;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceVariant,
      elevation: 0,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      semanticContainer: true,
      child: SizedBox(
        width: BookItemButtonSizes.width,
        height: BookItemButtonSizes.height,
        child: content(context),
      ),
    );
  }

  Widget shimmer(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final lightness = brightness == Brightness.dark ? 0.32 : 0.93;
    final color = HSLColor.fromColor(theme.colorScheme.surfaceVariant).withLightness(lightness).toColor();

    return Shimmer.fromColors(
      key: const Key('book_item_button_shimmer'),
      highlightColor: color,
      baseColor: theme.colorScheme.surfaceVariant,
      child: const Card(
        margin: EdgeInsets.all(0),
        child: SizedBox(
          width: BookItemButtonSizes.width,
          height: BookItemButtonSizes.height,
        ),
      ),
    );
  }

  Widget content(BuildContext context) {
    if (bookItem is! BookItem) return shimmer(context);

    return Stack(
      fit: StackFit.expand,
      key: const Key('book_item_stack'),
      children: [
        Positioned.fill(
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            cacheKey: bookItem!.slug,
            imageUrl: bookItem!.src,
            httpHeaders: bookItem!.scan.repository.headers,
            maxWidthDiskCache: BookItemButtonSizes.cacheMaxWidth,
            maxHeightDiskCache: BookItemButtonSizes.cacheMaxHeight,
            errorWidget: (context, url, error) => const Center(child: Icon(Icons.broken_image_rounded)),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            width: BookItemButtonSizes.width,
            alignment: Alignment.topLeft,
            child: BookItemFloatType(type: bookItem!.type?.toString().trim().toUpperCase()),
          ),
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(onTap: () => context.push(RoutePaths.book, extra: bookItem)),
          ),
        ),
      ],
    );
  }
}

abstract class BookItemButtonSizes {
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
