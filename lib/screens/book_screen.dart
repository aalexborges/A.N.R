import 'package:anr/models/book.dart';
import 'package:anr/stores/book_store.dart';
import 'package:anr/widgets/book_image_background.dart';
import 'package:anr/widgets/book_middle_actions.dart';
import 'package:anr/widgets/book_subtitle_infos.dart';
import 'package:anr/widgets/chapter_list_item.dart';
import 'package:anr/widgets/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class BookScreen extends StatefulWidget {
  const BookScreen({super.key, required this.book});

  final Book book;

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  late BookStore _store;
  double? _pinnedHeight;

  final _scrollController = ScrollController();

  void _scrollListener() {
    _pinnedHeight ??= (65 * MediaQuery.of(context).size.height) / 100;

    if (!_store.pinnedTitle && _scrollController.offset >= _pinnedHeight!) return _store.setPinnedTitle(true);
    if (_store.pinnedTitle && _scrollController.offset < _pinnedHeight!) return _store.setPinnedTitle(false);
  }

  @override
  void initState() {
    _store = BookStore()..getData(widget.book).catchError((_) => _snackBarError());
    _scrollController.addListener(_scrollListener);

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
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
                      return BookSubtitleInfos(book: widget.book, data: _store.data);
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
                      onPressChangeOrder: _store.data == null ? null : _store.toggleOrder,
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

                    return ChapterListItem(
                      key: Key(id),
                      chapter: chapter,
                      onTap: () => ChapterListItem.toDetails(
                        book: widget.book,
                        context: context,
                        chapters: _store.data!.chapters,
                        startAt: index,
                        order: _store.order,
                      ),
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
    final t = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);

    messenger.clearSnackBars();
    messenger.showSnackBar(SnackBar(content: Text(t.bookdDataError)));
  }
}
