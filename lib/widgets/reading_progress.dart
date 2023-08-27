import 'package:anr/service_locator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ReadingProgress extends StatelessWidget {
  const ReadingProgress({super.key, required this.slug, required this.firebaseId});

  final String slug;
  final String firebaseId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StreamBuilder(
      stream: readingHistoryRepository.chapterProgressStream(slug, firebaseId),
      builder: (context, snapshot) {
        final event = snapshot.data;

        if (event is! DatabaseEvent) return const SizedBox();

        final item = event.snapshot;

        if (!item.exists || item.value == null || item.value is! Map) return const SizedBox();

        final value = item.value as Map;
        final progress = value['progress'];

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
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                  child: Icon(
                    Icons.remove_red_eye_rounded,
                    size: 16,
                    color: theme.colorScheme.secondaryContainer,
                  ),
                ),
              ),
              Positioned.fill(
                child: CircularProgressIndicator(
                  value: progress / 100,
                  backgroundColor: theme.colorScheme.secondaryContainer,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
