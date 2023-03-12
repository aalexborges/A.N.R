import 'package:anr/models/content.dart';
import 'package:anr/models/scan.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class ContentListItem extends StatefulWidget {
  const ContentListItem({super.key, required this.scan, required this.content, this.onFinishedLoading});

  final Scan scan;
  final Content content;
  final void Function()? onFinishedLoading;

  @override
  State<ContentListItem> createState() => _ContentListItemState();
}

class _ContentListItemState extends State<ContentListItem> {
  int _amountOfLoaded = 0;
  bool _hasCalled = false;

  bool get _finishedLoadingImage {
    return _amountOfLoaded >= widget.content.items.length;
  }

  void _onFinishedLoadingImages() {
    if ((_hasCalled || widget.onFinishedLoading == null) && !_finishedLoadingImage) return;

    _amountOfLoaded++;

    if (_finishedLoadingImage) {
      _hasCalled = true;

      _getHeight();
      widget.onFinishedLoading!();
    }
  }

  void _getHeight() {
    if (widget.content.height != null) return;
    if (!widget.content.onlyText && !_finishedLoadingImage) return;

    final renderBox = context.findRenderObject() as RenderBox?;
    final size = renderBox?.size;

    if (size != null) widget.content.setHeight(size.height);
  }

  @override
  void initState() {
    if (widget.content.onlyText && widget.onFinishedLoading != null) {
      Future.delayed(const Duration(milliseconds: 400), () {
        widget.onFinishedLoading!();
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: widget.content.key,
      constraints: BoxConstraints(minHeight: widget.content.height ?? 0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Center(
              child: Text(
                widget.content.chapter.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          ListView.builder(
            physics: const ScrollPhysics(),
            itemCount: widget.content.items.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              if (widget.content.onlyText) {
                return Html(key: UniqueKey(), data: widget.content.items[index]);
              }

              return CachedNetworkImage(
                key: UniqueKey(),
                fit: BoxFit.fitWidth,
                imageUrl: widget.content.items[index],
                httpHeaders: widget.scan.repository.headers,
                errorWidget: _errorWidget,
                placeholder: _placeholder,
              );
            },
          ),
        ],
      ),
    );
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
    return _ContentImageLoading(
      key: Key(url),
      onDispose: _onFinishedLoadingImages,
    );
  }
}

class _ContentImageLoading extends StatefulWidget {
  const _ContentImageLoading({super.key, required this.onDispose});

  final void Function() onDispose;

  @override
  State<_ContentImageLoading> createState() => __ContentImageLoadingState();
}

class __ContentImageLoadingState extends State<_ContentImageLoading> {
  bool _wasDisposed = false;

  @override
  void dispose() {
    if (!_wasDisposed) {
      _wasDisposed = true;
      widget.onDispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      child: Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}
