import 'package:flutter/material.dart';

class ChapterTitleSeparator extends StatelessWidget {
  const ChapterTitleSeparator(this.name, {super.key});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Center(child: Text(name, style: Theme.of(context).textTheme.titleMedium)),
    );
  }
}
