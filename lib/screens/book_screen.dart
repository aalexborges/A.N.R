import 'package:anr/models/book.dart';
import 'package:anr/models/book_data.dart';
import 'package:anr/models/content.dart';
import 'package:anr/models/order.dart';
import 'package:anr/models/scan.dart';
import 'package:anr/router.dart';
import 'package:anr/stores/book_store.dart';
import 'package:anr/widgets/book_image_background.dart';
import 'package:anr/widgets/book_middle_actions.dart';
import 'package:anr/widgets/book_subtitle_infos.dart';
import 'package:anr/widgets/favorite_button.dart';
import 'package:anr/widgets/reading_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

class BookScreen extends StatefulWidget {
  const BookScreen({super.key, required this.book});

  final Book book;

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  final _store = BookStore();
  final _scrollController = ScrollController();

  double? _pinnedHeight;

  void _scrollListener() {
    _pinnedHeight ??= (65 * MediaQuery.of(context).size.height) / 100;

    if (!_store.pinnedTitle && _scrollController.offset >= _pinnedHeight!) return _store.setPinnedTitle(true);
    if (_store.pinnedTitle && _scrollController.offset < _pinnedHeight!) return _store.setPinnedTitle(false);
  }

  @override
  void initState() {
    super.initState();

    _store.getData(widget.book).catchError((_) => _snackBarError());
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final expandedHeight = (72 * MediaQuery.of(context).size.height) / 100;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {},
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              title: Observer(builder: (context) => _store.pinnedTitle ? Text(widget.book.name) : const SizedBox()),
              pinned: true,
              centerTitle: false,
              expandedHeight: expandedHeight,
              actions: [RepaintBoundary(child: FavoriteButton(book: widget.book))],
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: RepaintBoundary(
                  child: BookImageBackground(
                    book: widget.book,
                    child: Observer(builder: (context) {
                      return BookSubtitleInfos(
                        scan: widget.book.scan.value.toUpperCase(),
                        type: _store.data?.type ?? widget.book.type,
                        lastChapter: _store.chapters.isEmpty ? null : _store.data?.chapters.first.chapterNumber,
                        totalChapters: _store.chapters.isEmpty ? null : _store.data?.chapters.length.toString(),
                      );
                    }),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: RepaintBoundary(
                child: Observer(
                  builder: (context) {
                    return BookMiddleActions(
                      book: widget.book,
                      data: _store.data,
                      onPressChangeOrder: _store.data is! BookData ? null : _store.toggleOrder,
                    );
                  },
                ),
              ),
            ),
            Observer(builder: (context) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final chapter = _store.chapters[index];
                    final id = chapter.id.toString();

                    return ListTile(
                      key: Key(id),
                      title: Text(chapter.name),
                      trailing: ReadingHistory(slug: widget.book.slug, firebaseId: chapter.firebaseId),
                      onTap: () {
                        context.push(
                          ScreenPaths.content,
                          extra: ContentParams(
                            bookData: _store.data!,
                            chapterIndex: Order.realIndexBy(_store.order, index, _store.data!.chapters.length),
                          ),
                        );
                      },
                    );
                  },
                  childCount: _store.chapters.length,
                ),
              );
            })
          ],
        ),
      ),
    );
  }

  void _snackBarError() {
    if (mounted) {
      final t = AppLocalizations.of(context)!;
      final messenger = ScaffoldMessenger.of(context);

      messenger.clearSnackBars();
      messenger.showSnackBar(SnackBar(content: Text(t.bookDataError)));
    }
  }
}
