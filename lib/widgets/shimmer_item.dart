import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerItem extends StatelessWidget {
  const ShimmerItem({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final lightness = brightness == Brightness.dark ? 0.32 : 0.93;
    final color = HSLColor.fromColor(Theme.of(context).colorScheme.surfaceVariant).withLightness(lightness).toColor();

    return Shimmer.fromColors(
      highlightColor: color,
      baseColor: Theme.of(context).colorScheme.surfaceVariant,
      child: child,
    );
  }
}
