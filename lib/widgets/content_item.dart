import 'package:anr/models/content.dart';
import 'package:anr/models/scan.dart';
import 'package:anr/widgets/chapter_title_separator.dart';
import 'package:anr/widgets/measure_size.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart' as html;

class ContentItem extends StatefulWidget {
  const ContentItem({
    super.key,
    required this.scan,
    required this.content,
    required this.onChange,
    this.onFinishedLoadImages,
  });

  final Scan scan;
  final Content content;
  final void Function(Size) onChange;
  final void Function()? onFinishedLoadImages;

  @override
  State<ContentItem> createState() => _ContentItemState();
}

class _ContentItemState extends State<ContentItem> {
  int _loadedImages = 0;

  @override
  Widget build(BuildContext context) {
    if (!widget.content.hasContent) return const SizedBox();

    if (widget.content.isImage) {
      // return MeasureSize(onChange: onChange, child: ImagesMerge(content.images!));
      return MeasureSize(
        onChange: widget.onChange,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ChapterTitleSeparator(widget.content.title),
            ...widget.content.images!.map((source) {
              return CachedNetworkImage(
                fit: BoxFit.fitWidth,
                imageUrl: source,
                httpHeaders: widget.scan.repository.headers,
                errorWidget: _errorWidget,
                placeholder: _placeholder,
                imageBuilder: (context, imageProvider) {
                  _handleLoadedImages();
                  return Image(image: imageProvider);
                },
              );
            })
          ],
        ),
      );
    }

    return MeasureSize(onChange: widget.onChange, child: html.Html(data: widget.content.text));
  }

  Widget _errorWidget(BuildContext context, String url, dynamic error) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      child: Center(
        child: Icon(
          Icons.image_not_supported,
          color: Theme.of(context).colorScheme.error,
        ),
      ),
    );
  }

  Widget _placeholder(BuildContext context, String url) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      child: Center(child: CircularProgressIndicator.adaptive()),
    );
  }

  void _handleLoadedImages() {
    if (widget.onFinishedLoadImages is! Function || !widget.content.isImage) return;

    _loadedImages++;
    if (_loadedImages == widget.content.images!.length) widget.onFinishedLoadImages!();
  }
}
