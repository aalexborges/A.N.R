import 'package:anr/models/chapter.dart';
import 'package:anr/models/content.dart';
import 'package:anr/models/reader.dart';
import 'package:anr/models/scan.dart';
import 'package:anr/service_locator.dart';
import 'package:anr/widgets/background_blur.dart';
import 'package:anr/widgets/chapter_title_separator.dart';
import 'package:anr/widgets/content_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReaderScreen extends StatefulWidget {
  const ReaderScreen({super.key, required this.reader});

  final Reader reader;

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  List<Chapter> get chapters => widget.reader.bookData.chapters;

  final items = List<Content>.empty(growable: true);
  final chapterHeights = <int, double>{};
  final _scrollController = ScrollController();

  bool loading = true;
  int currentlyChapterIndex = -1;
  int currentlyVisibleIndex = -1;
  bool gettingNextChapter = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_scrollControllerListener);
    loadInitialChapter();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: InteractiveViewer(
              child: ListView.builder(
                physics: loading ? const NeverScrollableScrollPhysics() : null,
                cacheExtent: MediaQuery.of(context).size.height + 99911,
                controller: _scrollController,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ContentItem(
                    scan: widget.reader.bookItem.scan,
                    content: items[index],
                    onChange: (size) => (chapterHeights[index] = size.height),
                    onFinishedLoadImages: _onFinishedLoadImages,
                  );
                },
              ),
            ),
          ),
          Positioned.fill(child: loading ? const BackgroundBlur() : const SizedBox()),
          Positioned.fill(
            child: loading ? const Center(child: CircularProgressIndicator.adaptive()) : const SizedBox(),
          ),
        ],
      ),
    );
  }

  Future<void> _onFinishedLoadImages() async {
    if (loading) {
      await Future.delayed(const Duration(milliseconds: 250), () {
        setState(() {
          loading = false;
        });

        _continueByProgress();
      });
    }
  }

  Future<Content> loadChapterContent(int index) async {
    return await widget.reader.scan.repository.content(chapters[index]);
  }

  Future<void> loadInitialChapter() async {
    final content = await loadChapterContent(widget.reader.chapterIndex);

    setState(() {
      items.add(content);
      loading = content.isImage ? loading : false;
      currentlyChapterIndex = widget.reader.chapterIndex;
      currentlyVisibleIndex = 0;
    });

    await Future.delayed(const Duration(milliseconds: 100), _continueByProgress);
  }

  Future<void> getNextChapterContent() async {
    if (currentlyChapterIndex <= 0 || gettingNextChapter) return;
    gettingNextChapter = true;

    final content = await loadChapterContent(currentlyChapterIndex - 1);

    setState(() {
      items.add(content);
    });
  }

  Future<void> _continueByProgress() async {
    if (loading) return;

    final chapter = chapters[widget.reader.chapterIndex];
    final progress = await readingHistoryRepository.progress(widget.reader.bookItem.slug, chapter.firebaseId);

    if (progress > 0) _scrollController.jumpTo((_scrollController.position.maxScrollExtent * progress) / 100);
    _scrollController.jumpTo((_scrollController.position.maxScrollExtent * 70) / 100);
  }

  void _updateVisibleIndex() {
    final double itemHeight = chapterHeights[currentlyVisibleIndex] ?? 100;
    final int newIndex = (_scrollController.offset / itemHeight).floor();

    if (newIndex != currentlyVisibleIndex) currentlyVisibleIndex = newIndex;
  }

  Future<void> _scrollControllerListener() async {
    if (items.length > 1) _updateVisibleIndex();

    if (!gettingNextChapter) {
      if (_scrollController.position.pixels >= (0.72 * _scrollController.position.maxScrollExtent)) {
        await getNextChapterContent();
      }
    }

    // _removeOldChapters();
  }
}

// class ReaderScreen extends StatefulWidget {
//   const ReaderScreen({super.key, required this.reader});

//   final Reader reader;

//   @override
//   State<ReaderScreen> createState() => _ReaderScreenState();
// }

// class _ReaderScreenState extends State<ReaderScreen> {
//   List<Chapter> get chapters => widget.reader.bookData.chapters;

//   final _items = List<Content>.empty(growable: true);
//   final _chapterHeights = <int, double>{};
//   final _scrollController = ScrollController();

//   int currentlyChapterIndex = -1;
//   int currentlyVisibleIndex = -1;
//   bool gettingNextChapter = false;

//   @override
//   void initState() {
//     super.initState();

//     _scrollController.addListener(_scrollControllerListener);
//     loadInitialChapter();
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(body: _body());
//   }

//   Widget _body() {
//     if (_items.isEmpty) return const Center(child: CircularProgressIndicator.adaptive());

//     return InteractiveViewer(
//       child: ListView.separated(
//         controller: _scrollController,
//         itemCount: _items.length,
//         separatorBuilder: (context, index) => ChapterTitleSeparator(_items[index].title),
//         itemBuilder: (context, index) {
//           return ContentItem(
//             scan: widget.reader.bookItem.scan,
//             content: _items[index],
//             onChange: (size) => (_chapterHeights[index] = size.height),
//           );
//         },
//       ),
//     );
//   }

//   Future<Content> loadChapterContent(int index) async {
//     return await widget.reader.scan.repository.content(chapters[index]);
//   }

//   Future<void> loadInitialChapter() async {
//     final content = await loadChapterContent(widget.reader.chapterIndex);

//     setState(() {
//       _items.add(content);
//       currentlyChapterIndex = widget.reader.chapterIndex;
//     });

//     await Future.delayed(const Duration(milliseconds: 100), () async {
//       final chapter = chapters[widget.reader.chapterIndex];
//       final progress = await readingHistoryRepository.progress(widget.reader.bookItem.slug, chapter.firebaseId);

//       if (progress > 0) _scrollController.jumpTo((_scrollController.position.maxScrollExtent * progress) / 100);
//       _scrollController.jumpTo((_scrollController.position.maxScrollExtent * 78) / 100);
//     });
//   }

//   Future<void> getNextChapterContent() async {
//     if (currentlyChapterIndex <= 0 || gettingNextChapter) return;
//     gettingNextChapter = true;

//     final content = await loadChapterContent(currentlyChapterIndex - 1);

//     setState(() {
//       _items.add(content);
//       gettingNextChapter = false;
//     });
//   }

//   void _updateVisibleIndex() {
//     final double itemHeight = _chapterHeights[currentlyVisibleIndex] ?? 100;
//     final int newIndex = (_scrollController.offset / itemHeight).floor();

//     if (newIndex != currentlyVisibleIndex) currentlyVisibleIndex = newIndex;
//   }

//   void _removeOldChapters() {
//     const int bufferCount = 3; // Quantidade de itens extras além dos visíveis

//     for (int i = 0; i < _items.length; i++) {
//       final double itemHeight = _chapterHeights[i] ?? 0;

//       if ((_scrollController.offset - i * itemHeight).abs() > bufferCount * itemHeight) {
//         setState(() {
//           _items.removeRange(0, i);
//         });

//         break;
//       }
//     }
//   }

//   Future<void> _scrollControllerListener() async {
//     _updateVisibleIndex();

//     if (!gettingNextChapter) {
//       if (_scrollController.position.pixels >= (0.80 * _scrollController.position.maxScrollExtent)) {
//         print('Obtendo proximo capitulo');
//         await getNextChapterContent();
//       }
//     }

//     print(currentlyVisibleIndex);

//     // _removeOldChapters();
//   }
// }
