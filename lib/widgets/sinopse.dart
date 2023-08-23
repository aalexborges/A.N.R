import 'package:anr/widgets/shimmer_item.dart';
import 'package:flutter/material.dart';

class Sinopse extends StatelessWidget {
  const Sinopse({super.key, this.sinopse, this.maxLines});

  final int? maxLines;
  final String? sinopse;

  @override
  Widget build(BuildContext context) {
    if (sinopse is String) return Text(sinopse!, maxLines: maxLines, overflow: TextOverflow.ellipsis);

    return const ShimmerItem(
      child: Card(
        margin: EdgeInsets.all(0),
        child: SizedBox(
          width: double.infinity,
          height: 60,
        ),
      ),
    );
  }
}
