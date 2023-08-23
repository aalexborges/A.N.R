import 'package:anr/models/book_item.dart';
import 'package:anr/widgets/favorite_button.dart';
import 'package:flutter/material.dart';

class BookScreenAppBar extends StatefulWidget {
  const BookScreenAppBar({super.key, required this.bookItem, required this.controller, required this.expandedHeight});

  final BookItem bookItem;
  final ScrollController controller;
  final double expandedHeight;

  @override
  State<BookScreenAppBar> createState() => _BookScreenAppBarState();
}

class _BookScreenAppBarState extends State<BookScreenAppBar> {
  bool pinned = false;

  void onScrollListener() {
    final pinnedHeight = (62 * MediaQuery.of(context).size.height) / 100;

    if (!pinned && widget.controller.offset >= pinnedHeight) {
      setState(() {
        pinned = true;
      });
    }

    if (pinned && widget.controller.offset < pinnedHeight) {
      setState(() {
        pinned = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(onScrollListener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(onScrollListener);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: pinned ? Text(widget.bookItem.name) : null,
      pinned: true,
      actions: [RepaintBoundary(child: FavoriteButton(bookItem: widget.bookItem))],
      centerTitle: false,
      backgroundColor: pinned ? null : Colors.transparent,
      expandedHeight: widget.expandedHeight,
      flexibleSpace: FlexibleSpaceBar(
        title: middleTitle(context),
        background: gradientBackground(context),
        centerTitle: false,
        collapseMode: CollapseMode.pin,
        titlePadding: const EdgeInsets.symmetric(horizontal: 16),
        expandedTitleScale: 1,
      ),
    );
  }

  Widget? middleTitle(BuildContext context) {
    if (pinned) return null;

    return Text(
      widget.bookItem.name,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
    );
  }

  Widget? gradientBackground(BuildContext context) {
    if (pinned) return null;

    final gradientBackground = Theme.of(context).colorScheme.background;

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                end: Alignment.bottomCenter,
                begin: Alignment.topCenter,
                stops: const [0.5, 1],
                colors: [Colors.transparent, gradientBackground],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
