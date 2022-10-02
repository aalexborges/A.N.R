import 'dart:convert';

import 'package:A.N.R/constants/scans.dart';
import 'package:A.N.R/database/downloads_db.dart';
import 'package:A.N.R/models/book.model.dart';
import 'package:A.N.R/models/chapter.model.dart';
import 'package:A.N.R/models/content.model.dart';
import 'package:A.N.R/services/reader.service.dart';
import 'package:A.N.R/store/historic.store.dart';
import 'package:A.N.R/templates/reader_html.template.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ReaderScreen extends StatefulWidget {
  final ReaderProps props;

  const ReaderScreen(this.props, {super.key});

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen>
    with WidgetsBindingObserver {
  String initialUrl = Uri.dataFromString(
    readerHTMLTemplate,
    mimeType: 'text/html',
    encoding: Encoding.getByName('utf-8'),
  ).toString();

  late ReaderService service;
  late HistoricStore historic;

  bool finished = false;
  bool ready = false;

  int currentIndex = 0;
  double currentRead = 0;

  Future<void> _content(int index) async {
    final chapter = widget.props.chapters[index];

    Content? content = await DownloadsDB.instance.content(
      chapter.bookId,
      chapter.id,
      index,
    );

    content ??= await widget.props.book.scan.repository.content(
      chapter,
      index,
    );

    await service.insert(content);
  }

  void _updateCurrentHistoric() {
    if (currentRead > 0) {
      historic.upsert(
        bookId: widget.props.book.id,
        chapterId: widget.props.chapters[currentIndex].id,
        read: currentRead,
      );
    }
  }

  void _onFinished(JavascriptMessage message) {
    final data = jsonDecode(message.message);

    historic.upsert(
      bookId: widget.props.book.id,
      chapterId: data['id'],
      read: double.parse(data['read'].toString()),
    );
  }

  void _onLoading(JavascriptMessage message) {
    if (currentIndex != widget.props.startedIndex) return;

    final chapter = widget.props.chapters[currentIndex];
    final read = historic.historic[widget.props.book.id]?[chapter.id];

    if (read != null) service.continueBy(read);
  }

  void _onNext(JavascriptMessage message) {
    if (currentIndex <= 0) {
      if (!finished) service.finished();
      return;
    }

    _content(currentIndex - 1);
  }

  void _onPosition(JavascriptMessage message) {
    final data = jsonDecode(message.message);

    currentIndex = data['index'] ?? currentIndex;
    currentRead = data['read'] ?? currentRead;
  }

  @override
  void initState() {
    currentIndex = widget.props.startedIndex;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    historic = Provider.of<HistoricStore>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: initialUrl,
      javascriptMode: JavascriptMode.unrestricted,
      backgroundColor: Colors.black,
      gestureNavigationEnabled: true,
      javascriptChannels: {
        JavascriptChannel(name: 'onNext', onMessageReceived: _onNext),
        JavascriptChannel(name: 'onLoading', onMessageReceived: _onLoading),
        JavascriptChannel(name: 'onFinished', onMessageReceived: _onFinished),
        JavascriptChannel(name: 'onPosition', onMessageReceived: _onPosition),
      },
      onWebViewCreated: (controller) {
        service = ReaderService(controller);

        if (!ready) {
          _content(widget.props.startedIndex);
          ready = true;
        }
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final isInactive = state == AppLifecycleState.inactive;
    final isDetached = state == AppLifecycleState.detached;

    if (isInactive || isDetached) _updateCurrentHistoric();

    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    _updateCurrentHistoric();
    super.dispose();
  }
}

class ReaderProps {
  final Book book;
  final List<Chapter> chapters;
  final int startedIndex;

  const ReaderProps({
    required this.book,
    required this.chapters,
    required this.startedIndex,
  });
}
