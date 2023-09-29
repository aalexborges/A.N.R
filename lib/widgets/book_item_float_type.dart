import 'package:flutter/material.dart';

class BookItemFloatType extends StatelessWidget {
  const BookItemFloatType({super.key, this.type});

  final String? type;

  @override
  Widget build(BuildContext context) {
    if (type is String && type!.isNotEmpty) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: FittedBox(
            child: Text(
              type!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
              maxLines: 1,
            ),
          ),
        ),
      );
    }

    return const SizedBox();
  }
}
