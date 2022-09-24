import 'package:A.N.R/constants/scans.dart';
import 'package:A.N.R/widgets/shimmer.widget.dart';
import 'package:flutter/material.dart';

class BookSubtitleInfosWidget extends StatelessWidget {
  final int totalChapters;
  final Scans scan;
  final String type;

  final bool? isLoading;

  const BookSubtitleInfosWidget({
    required this.scan,
    required this.type,
    required this.totalChapters,
    this.isLoading,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading == true) {
      return ShimmerWidget(
        width: (MediaQuery.of(context).size.width / 100) * 72,
        height: 22,
        margin: const EdgeInsets.only(bottom: 8),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _text('$totalChapters capítulos', context),
          _separator(context),
          _text(type, context),
          _separator(context),
          _text(scan.value, context),
        ],
      ),
    );
  }

  Widget _separator(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSecondary,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  Widget _text(String value, BuildContext context) {
    return Text(
      value,
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins',
        decoration: TextDecoration.none,
      ),
    );
  }
}
