import 'package:flutter/material.dart';

class ContentItemImageError extends StatelessWidget {
  const ContentItemImageError({super.key});

  @override
  Widget build(BuildContext context) {
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
}
