import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerItem extends StatelessWidget {
  const ShimmerItem({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lightness = theme.brightness == Brightness.dark ? 0.32 : 0.93;
    final color = HSLColor.fromColor(theme.colorScheme.surfaceVariant).withLightness(lightness).toColor();

    return Shimmer.fromColors(
      highlightColor: color,
      baseColor: theme.colorScheme.surfaceVariant,
      child: child,
    );
  }
}
