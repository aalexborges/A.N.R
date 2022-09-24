import 'package:A.N.R/widgets/shimmer.widget.dart';
import 'package:flutter/material.dart';

class SinopseWidget extends StatelessWidget {
  final String text;

  final bool? short;
  final bool? isLoading;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const SinopseWidget(
    this.text, {
    this.isLoading,
    this.padding,
    this.margin,
    this.short,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading == true) {
      return ShimmerWidget(
        width: double.infinity,
        height: 72,
        margin: margin,
        padding: padding,
      );
    }

    return Container(
      margin: margin,
      padding: padding,
      alignment: Alignment.topLeft,
      child: Text(
        text,
        maxLines: short == true ? 3 : null,
        overflow: short == true ? TextOverflow.ellipsis : null,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontFamily: 'Poppins',
          decoration: TextDecoration.none,
        ),
      ),
    );
  }
}
