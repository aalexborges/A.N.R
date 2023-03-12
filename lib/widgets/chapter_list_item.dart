import 'package:anr/models/book.dart';
import 'package:anr/models/chapter.dart';
import 'package:anr/models/content.dart';
import 'package:anr/models/order.dart';
import 'package:anr/router.dart';
import 'package:anr/widgets/reading_history_progress.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChapterListItem extends StatelessWidget {
  const ChapterListItem({super.key, required this.chapter, this.onTap});

  final Chapter chapter;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(chapter.name),
      trailing: ReadingHistoryProgress(chapter: chapter),
      onTap: onTap,
    );
  }

  static toDetails({
    required BuildContext context,
    required Book book,
    required Order order,
    required List<Chapter> chapters,
    required int startAt,
  }) {
    context.push(
      ScreenPaths.content,
      extra: ContentParams(
        scan: book.scan,
        chapters: chapters,
        startAt: ContentParams.startByOrder(startAt, order, chapters.length),
      ),
    );
  }
}
