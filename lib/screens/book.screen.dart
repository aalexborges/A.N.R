import 'dart:isolate';
import 'dart:ui';

import 'package:A.N.R/constants/order.dart';
import 'package:A.N.R/constants/ports.dart';
import 'package:A.N.R/constants/routes_path.dart';
import 'package:A.N.R/models/book.model.dart';
import 'package:A.N.R/models/book_download.model.dart';
import 'package:A.N.R/models/download_update.dart';
import 'package:A.N.R/screens/about.screen.dart';
import 'package:A.N.R/screens/reader.screen.dart';
import 'package:A.N.R/store/book.store.dart';
import 'package:A.N.R/store/download.store.dart';
import 'package:A.N.R/widgets/book_app_bar_background.widget.dart';
import 'package:A.N.R/widgets/book_chapters_title.widget.dart';
import 'package:A.N.R/widgets/book_subtitle_infos.widget.dart';
import 'package:A.N.R/widgets/chapter_list_tile.widget.dart';
import 'package:A.N.R/widgets/download_all_button_widget.dart';
import 'package:A.N.R/widgets/favorite_button.widget.dart';
import 'package:A.N.R/widgets/read_button.widget.dart';
import 'package:A.N.R/widgets/sinopse.widget.dart';
import 'package:A.N.R/widgets/to_about_book_button.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class BookScreen extends StatefulWidget {
  final Book book;

  const BookScreen({required this.book, super.key});

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  late BookStore _store;
  late DownloadStore _downloadStore;

  final _port = ReceivePort();
  final _scroll = ScrollController();

  void _scrollListener() {
    final double height = (70 * MediaQuery.of(context).size.height) / 100;

    if (!_store.pinnedTitle && _scroll.offset >= height) {
      _store.setPinnedTitle(true);
    } else if (_store.pinnedTitle && _scroll.offset < height) {
      _store.setPinnedTitle(false);
    }
  }

  void _downloadedListener(dynamic message) {
    final data = message as DownloadUpdate;

    if (data.bookId == widget.book.id) {
      _downloadStore.addFinishedChapter(data.chapterId);
    }
  }

  @override
  void initState() {
    _store = BookStore();
    _store.getData(widget.book).catchError((_) {
      final messenger = ScaffoldMessenger.of(context);

      messenger.clearSnackBars();
      messenger.showSnackBar(const SnackBar(
        content: Text('Algo deu errado ao obter as informações do livro'),
      ));
    });

    _scroll.addListener(_scrollListener);

    IsolateNameServer.registerPortWithName(_port.sendPort, Ports.DOWNLOADED);
    _port.listen(_downloadedListener);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _downloadStore = Provider.of<DownloadStore>(context)
      ..populate(widget.book.id);

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scroll.removeListener(_scrollListener);
    _port.close();

    IsolateNameServer.removePortNameMapping(Ports.DOWNLOADED);
    _downloadStore.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      body: RefreshIndicator(
        onRefresh: () => _store.getData(widget.book),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          controller: _scroll,
          slivers: [
            SliverAppBar(
              title: Observer(builder: (context) {
                return Text(_store.pinnedTitle ? widget.book.name : '');
              }),
              pinned: true,
              centerTitle: false,
              expandedHeight: (74 * MediaQuery.of(context).size.height) / 100,
              backgroundColor: Theme.of(context).primaryColorDark,
              actions: [
                RepaintBoundary(child: FavoriteButtonWidget(widget.book)),
              ],
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: RepaintBoundary(
                  child: BookAppBarBackgroundWidget(
                    book: widget.book,
                    subtitle: Observer(builder: (context) {
                      return BookSubtitleInfosWidget(
                        scan: widget.book.scan,
                        type: _store.data?.type ?? 'Tipo Desconhecido',
                        totalChapters: _store.data?.chapters.length ?? 0,
                        isLoading: _store.isLoading,
                      );
                    }),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Observer(builder: (context) {
                  return RepaintBoundary(
                    child: Column(
                      children: [
                        SinopseWidget(
                          _store.data?.sinopse ?? '',
                          isLoading: _store.isLoading,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          short: true,
                        ),
                        ToAboutBookButtonWidget(
                          isLoading: _store.isLoading,
                          type: _store.data?.type ?? widget.book.type,
                          onPressed: () => context.push(
                            RoutesPath.ABOUT,
                            extra: AboutProps(
                              book: widget.book,
                              data: _store.data!,
                            ),
                          ),
                        ),
                        ReadButtonWidget(
                          book: widget.book,
                          chapters: _store.data?.chapters ?? [],
                        ),
                        BookChaptersTitleWidget(
                          onChangeOrder: _store.toggleOrder,
                          secondary: DownloadAllButtonWidget(
                            book: widget.book,
                            bookData: _store.data,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            Observer(builder: (context) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return ChapterListTileWidget(
                      bookId: widget.book.id,
                      chapter: _store.chapters[index],
                      onTap: () {
                        final startedIndex = _store.order == Order.ASC
                            ? _store.chapters.length - (index + 1)
                            : index;

                        context.push(
                          RoutesPath.READER,
                          extra: ReaderProps(
                            book: widget.book,
                            chapters: _store.data!.chapters,
                            startedIndex: startedIndex,
                          ),
                        );
                      },
                      downloadBook: BookDownload(
                        scan: widget.book.scan,
                        url: widget.book.url,
                        name: widget.book.name,
                        type: _store.data?.type ?? widget.book.type,
                        sinopse: _store.data!.sinopse,
                        imageURL: widget.book.imageURL,
                        imageURL2: widget.book.imageURL2,
                        categories: _store.data!.categories,
                      ),
                    );
                  },
                  childCount: _store.chapters.length,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
