import 'package:A.N.R/widgets/book.widget.dart';
import 'package:A.N.R/widgets/shimmer.widget.dart';
import 'package:flutter/material.dart';

class BookShimmerWidget extends StatelessWidget {
  final EdgeInsetsGeometry? margin;

  const BookShimmerWidget({this.margin, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShimmerWidget(
      width: bookWidth,
      height: bookHeight,
      margin: margin,
    );
  }
}
