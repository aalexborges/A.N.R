import 'package:A.N.R/models/content.model.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ReaderService {
  final WebViewController controller;

  const ReaderService(this.controller);

  Future<void> insert(Content content) async {
    if (content.sources != null) {
      await controller.runJavascript("Chapter.insert('${content.toJson()}')");
      return;
    }

    await controller.runJavascript("""
      Chapter.insert(JSON.stringify({
        id: '${content.id}',
        name: '${content.name}',
        index: ${content.index},
        content: `${content.text}`,
      }));
    """);
  }

  Future<void> continueBy(double progress) async {
    await controller.runJavascript('Chapter.continueBy($progress)');
  }

  Future<void> finished() async {
    await controller.runJavascript('Chapter.finished()');
  }
}
