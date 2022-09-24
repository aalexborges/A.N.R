import 'package:A.N.R/widgets/book.widget.dart';
import 'package:flutter/material.dart';

const gridBookDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
  mainAxisSpacing: 8,
  crossAxisSpacing: 8,
  childAspectRatio: 0.72,
  maxCrossAxisExtent: bookHeight,
);
