import 'package:anr/models/chapter.dart';
import 'package:anr/repositories/reading_history_repository.dart';
import 'package:flutter/material.dart';

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
}
