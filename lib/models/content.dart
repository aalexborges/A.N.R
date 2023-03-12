import 'package:anr/models/chapter.dart';
import 'package:anr/models/order.dart';
import 'package:anr/models/scan.dart';
import 'package:flutter/material.dart';

class ContentParams {
  const ContentParams({required this.scan, required this.chapters, required this.startAt});

  final Scan scan;
  final List<Chapter> chapters;
  final int startAt;

  static int startByOrder(int startAt, Order order, int chaptersLength) {
    return order == Order.asc ? chaptersLength - (startAt + 1) : startAt;
  }
}

class Content {
  Content({
    required this.key,
    required this.chapter,
    required this.items,
    this.onlyText = false,
    this.height,
  });

  final bool onlyText;
  final Chapter chapter;
  final List<String> items;
  final GlobalObjectKey key;
  double? height;

  double get readingProgress {
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    final size = renderBox?.size;
    final offset = renderBox?.localToGlobal(Offset.zero);

    if (size == null || offset == null) return 0;
    if (offset.dy > 0) return 0;

    final readingProgress = ((offset.dy / size.height) * 100).abs();
    return readingProgress >= 99 ? 100 : readingProgress;
  }

  void setHeight(double value) {
    height = value;
  }
}
