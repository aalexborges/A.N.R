import 'package:flutter/material.dart';

class BookChaptersTitleWidget extends StatelessWidget {
  final Widget? secondary;
  final void Function()? onChangeOrder;

  const BookChaptersTitleWidget({
    this.secondary,
    this.onChangeOrder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Capítulos',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Row(
            children: [
              SizedBox(child: secondary),
              IconButton(
                onPressed: onChangeOrder,
                icon: const Icon(Icons.sort_by_alpha_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
