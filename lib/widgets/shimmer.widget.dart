import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;

  final double? borderRadius;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const ShimmerWidget({
    required this.width,
    required this.height,
    this.borderRadius,
    this.padding,
    this.margin,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      child: Shimmer.fromColors(
        highlightColor: Colors.white54,
        baseColor: Colors.white38,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white12,
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
          ),
        ),
      ),
    );
  }
}
