import 'package:anr/models/content.dart';
import 'package:anr/widgets/content_item.dart';
import 'package:flutter/material.dart';

class ContentItemWithLoading extends StatefulWidget {
  const ContentItemWithLoading({super.key, required this.content, required this.onLoaded, this.headers});

  final Content content;
  final Map<String, String>? headers;
  final void Function() onLoaded;

  @override
  State<ContentItemWithLoading> createState() => _ContentItemWithLoadingState();
}

class _ContentItemWithLoadingState extends State<ContentItemWithLoading> {
  bool loading = true;
  int loadedImages = 0;

  void _handleLoadedImage() {
    if (widget.content.isImage && loading) {
      loadedImages++;

      if (loadedImages == widget.content.images!.length) {
        loading = false;
        widget.onLoaded();
      }
    }
  }

  @override
  void initState() {
    super.initState();

    if (!widget.content.isImage && loading) {
      loading = false;
      widget.onLoaded();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ContentItem(
      content: widget.content,
      headers: widget.headers,
      imageBuilder: (context, imageProvider) {
        _handleLoadedImage();
        return Image(image: imageProvider);
      },
      imagePlaceholder: (context, url) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 16),
          child: Center(child: CircularProgressIndicator.adaptive()),
        );
      },
    );
  }
}
