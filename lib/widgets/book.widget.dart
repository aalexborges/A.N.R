import 'dart:convert';

import 'package:A.N.R/constants/scans.dart';
import 'package:A.N.R/models/book.model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

const bookWidth = 112.0;
const bookHeight = 158.49;

class BookWidget extends StatelessWidget {
  final Book book;
  final Widget? bottom;
  final EdgeInsetsGeometry? margin;

  final Function()? onLongPress;
  final Function() onTap;

  const BookWidget({
    required this.onTap,
    required this.book,
    this.onLongPress,
    this.bottom,
    this.margin,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: bookWidth,
          height: bookHeight,
          color: const Color.fromRGBO(255, 255, 255, 0.05),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: image(
                  book.imageURL,
                  errorBuilder: (context, p1, p2) {
                    final imageURL2 = book.imageURL2 ?? '';

                    if (imageURL2.isEmpty) return Container(color: Colors.grey);
                    return image(imageURL2);
                  },
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _floatItems,
                  ),
                ),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(onTap: onTap, onLongPress: onLongPress),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget image(
    String src, {
    Widget Function(BuildContext, String, dynamic)? errorBuilder,
  }) {
    if (src.contains('base64')) {
      final replacedSrc = src.split(';base64,').last;
      final bytes = base64.decode(replacedSrc);

      return Image.memory(
        bytes,
        fit: BoxFit.cover,
        cacheHeight: bookHeight.ceil(),
        cacheWidth: bookWidth.ceil(),
      );
    }

    return CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: src,
      errorWidget: errorBuilder,
      httpHeaders: book.scan.repository.headers,
    );
  }

  List<Widget> get _floatItems {
    final items = <Widget>[];

    if (book.type != null && book.type!.isNotEmpty) items.add(_typeWidget);
    if (bottom != null) items.add(bottom!);

    return items;
  }

  Widget get _typeWidget {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 6),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(22, 22, 30, 0.8),
        borderRadius: BorderRadius.circular(6),
      ),
      constraints: const BoxConstraints(maxWidth: bookWidth),
      child: FittedBox(
        child: Text(
          '${book.type}',
          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
          maxLines: 1,
        ),
      ),
    );
  }
}
