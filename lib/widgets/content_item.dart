import 'package:anr/models/content.dart';
import 'package:anr/widgets/content_item_image_error.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart' as html;

class ContentItem extends StatelessWidget {
  const ContentItem({super.key, required this.content, this.headers, this.imageBuilder, this.imagePlaceholder});

  final Content content;
  final Map<String, String>? headers;
  final Widget Function(BuildContext context, ImageProvider<Object> imageProvider)? imageBuilder;
  final Widget Function(BuildContext context, String url)? imagePlaceholder;

  @override
  Widget build(BuildContext context) {
    if (!content.hasContent) return const SizedBox();

    if (content.isImage) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Center(child: Text(content.title, style: Theme.of(context).textTheme.titleMedium)),
          ),
          ListView.builder(
            physics: const ScrollPhysics(),
            itemCount: content.images!.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                fit: BoxFit.fitWidth,
                imageUrl: content.images![index],
                httpHeaders: headers,
                errorWidget: (context, url, error) => const ContentItemImageError(),
                imageBuilder: imageBuilder,
                placeholder: imagePlaceholder,
              );
            },
          ),
          // ListView(
          //   physics: const ScrollPhysics(),
          //   shrinkWrap: true,
          //   children: content.images!.map((source) {
          //     return CachedNetworkImage(
          //       fit: BoxFit.fitWidth,
          //       imageUrl: source,
          //       httpHeaders: headers,
          //       errorWidget: (context, url, error) => const ContentItemImageError(),
          //       imageBuilder: imageBuilder,
          //       placeholder: imagePlaceholder,
          //     );
          //   }).toList(),
          // ),
        ],
      );
    }

    return html.Html(data: content.text);
  }
}
