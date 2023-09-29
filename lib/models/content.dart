import 'package:anr/models/book.dart';
import 'package:anr/models/book_data.dart';
import 'package:anr/models/chapter.dart';
import 'package:anr/models/scan.dart';
import 'package:flutter/material.dart';

class ContentParams {
  const ContentParams({required this.bookData, required this.chapterIndex});

  final BookData bookData;
  final int chapterIndex;

  Scan get scan => book.scan;
  Book get book => bookData.book;
  List<Chapter> get chapters => bookData.chapters;
}

class Content {
  const Content({required this.key, required this.title, this.text, this.images});

  final String title;
  final String? text;
  final List<String>? images;
  final GlobalObjectKey key;

  bool get isImage => images is List && text is! String;
  bool get hasContent => (text is String && text!.isNotEmpty) || (images is List && images!.isNotEmpty);

  double get readingProgress {
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    final size = renderBox?.size;
    final offset = renderBox?.localToGlobal(Offset.zero);

    if (size is! Size || offset is! Offset) return 0;
    if (offset.dy > 0) return 0;

    final readingProgress = ((offset.dy / size.height) * 100).abs();
    return readingProgress >= 99 ? 100 : readingProgress;
  }
}
