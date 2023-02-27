import 'package:anr/models/book.dart';
import 'package:anr/models/chapter.dart';
import 'package:anr/models/content.dart';
import 'package:anr/models/order.dart';
import 'package:anr/repositories/reading_history_repository.dart';
import 'package:anr/router.dart';
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
      trailing: ReadingHistoryRepository.I.progressWidget(chapter),
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
      extra: Content(
        book: book,
        chapters: chapters,
        startAt: Content.startByOrder(startAt, order, chapters.length),
      ),
    );
  }
}
