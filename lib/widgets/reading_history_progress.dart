import 'package:anr/models/chapter.dart';
import 'package:anr/repositories/reading_history_repository.dart';
import 'package:flutter/material.dart';

class ReadingHistoryProgress extends StatefulWidget {
  const ReadingHistoryProgress({required this.chapter, super.key});

  final Chapter chapter;

  @override
  State<ReadingHistoryProgress> createState() => _ReadingHistoryProgressState();
}

class _ReadingHistoryProgressState extends State<ReadingHistoryProgress> {
  double _readingProgress = 0;

  void _readingProgressListener() {
    setState(() => _readingProgress = widget.chapter.readingProgress);
  }

  @override
  void initState() {
    _readingProgress = widget.chapter.readingProgress;

    widget.chapter.addListener(_readingProgressListener);
    ReadingHistoryRepository.I.progress(widget.chapter);

    super.initState();
  }

  @override
  void dispose() {
    widget.chapter.removeListener(_readingProgressListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_readingProgress < 1) return const SizedBox();

    return Container(
      width: 28,
      height: 28,
      margin: const EdgeInsets.only(left: 16),
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              child: Icon(
                Icons.remove_red_eye_rounded,
                size: 16,
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),
            ),
          ),
          Positioned.fill(
            child: CircularProgressIndicator(
              value: _readingProgress / 100,
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
