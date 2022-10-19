import 'dart:convert';

import 'package:A.N.R/constants/scans.dart';
import 'package:A.N.R/models/book.model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BookAppBarBackgroundWidget extends StatelessWidget {
  final Book book;
  final Widget subtitle;

  const BookAppBarBackgroundWidget({
    required this.book,
    required this.subtitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(child: bgImage()),
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
                  Theme.of(context).primaryColorDark,
                  Colors.transparent,
                  Theme.of(context).primaryColorDark,
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle,
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget bgImage() {
    if (book.imageURL.contains('base64')) {
      final replacedSrc = book.imageURL.split(';base64,').last;
      final bytes = base64.decode(replacedSrc);

      return Image.memory(
        bytes,
        fit: BoxFit.cover,
      );
    }

    return CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: book.imageURL,
      httpHeaders: book.scan.repository.headers,
      errorWidget: (context, url, error) {
        final imageURL2 = book.imageURL2;

        if (imageURL2 == null || imageURL2.isEmpty) return const SizedBox();

        return CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: imageURL2,
        );
      },
    );
  }
}
