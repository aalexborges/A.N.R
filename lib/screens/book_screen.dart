import 'package:anr/models/book_data.dart';
import 'package:anr/models/book_item.dart';
import 'package:anr/models/chapter.dart';
import 'package:anr/models/reader.dart';
import 'package:anr/models/scan.dart';
import 'package:anr/utils/route_paths.dart';
import 'package:anr/widgets/book_data_subtitle_infos.dart';
import 'package:anr/widgets/book_item_button.dart';
import 'package:anr/widgets/book_screen_app_bar.dart';
import 'package:anr/widgets/continue_reading.dart';
import 'package:anr/widgets/reading_progress.dart';
import 'package:anr/widgets/sinopse.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class BookScreen extends StatefulWidget {
  const BookScreen({super.key, required this.bookItem});

  final BookItem bookItem;

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  final controller = ScrollController();

  BookData? bookData;

  List<Chapter> get chapters => bookData?.chapters ?? List.empty(growable: false);

  Future<void> loadBookData({bool forceUpdate = false}) async {
    final data = await widget.bookItem.getData(forceUpdate: forceUpdate);

    setState(() {
      bookData = data;
    });
  }

  void toDetails() {
    if (bookData is BookData) context.push(RoutePaths.details, extra: bookData);
  }

  @override
  void initState() {
    super.initState();
    loadBookData();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final i10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final expandedHeight = (70 * MediaQuery.of(context).size.height) / 100;

    return Scaffold(
      body: Stack(fit: StackFit.expand, children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            height: expandedHeight,
            cacheKey: widget.bookItem.slug,
            imageUrl: widget.bookItem.src,
            httpHeaders: widget.bookItem.scan.repository.headers,
            maxWidthDiskCache: BookItemButtonSizes.cacheMaxWidth,
            maxHeightDiskCache: BookItemButtonSizes.cacheMaxHeight,
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 56 + MediaQuery.of(context).padding.top,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                end: Alignment.bottomCenter,
                begin: Alignment.topCenter,
                stops: const [0.30, 1],
                colors: [theme.colorScheme.background, Colors.transparent],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: RefreshIndicator(
            onRefresh: () => loadBookData(forceUpdate: true),
            child: NestedScrollView(
              controller: controller,
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                BookScreenAppBar(
                  bookItem: widget.bookItem,
                  controller: controller,
                  expandedHeight: expandedHeight,
                ),
              ],
              body: Container(
                color: theme.colorScheme.background,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(children: [
                          BookDataSubtitleInfos(
                            scan: widget.bookItem.scan.value.toUpperCase(),
                            type: bookData?.type ?? widget.bookItem.type,
                          ),
                          Sinopse(
                            sinopse: bookData?.sinopse,
                            maxLines: 3,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 2, bottom: 2),
                            child: TextButton(
                              onPressed: bookData is BookData ? toDetails : null,
                              child: Text(i10n.bookDetails),
                            ),
                          ),
                          ContinueReading(bookData: bookData),
                        ]),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final chapter = chapters[index];

                        return ListTile(
                          title: Text(chapter.name),
                          trailing: ReadingProgress(slug: widget.bookItem.slug, firebaseId: chapter.firebaseId),
                          onTap: () {
                            context.push(
                              RoutePaths.reader,
                              extra: Reader(
                                bookData: bookData!,
                                chapterIndex: index,
                              ),
                            );
                          },
                        );
                      }, childCount: chapters.length),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
