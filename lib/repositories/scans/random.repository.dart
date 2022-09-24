part of 'scan.repository.dart';

class RandomRepository extends ScanRepositoryBase {
  @override
  final String baseURL = 'https://randomscans.com';

  @override
  final baseURLs = <String>[
    'https://randomscans.com',
    'https://randomscan.online',
  ];

  RandomRepository() {
    _cache = DioCache(url: baseURL);
    _dio = Dio()..interceptors.add(_cache.cache.interceptor);
  }

  @override
  Future<List<Book>> lastAdded() async {
    final books = <Book>[];

    try {
      final webView = await _request(baseURL);
      final controller = webView.webViewController;

      final items = await controller.callAsyncJavaScript(
        functionBody: _lastAddedJs,
      );

      for (var element in (items?.value ?? [])) {
        books.add(Book.fromMap(element));
      }

      await webView.dispose();
      return books;
    } catch (_) {
      return books;
    }
  }

  @override
  Future<List<Book>> search(String value) async {
    final books = <Book>[];

    final subKey = '?s=$value&post_type=wp-manga';
    final url = '$baseURL/$subKey';

    final webView = await _request(url);
    final controller = webView.webViewController;

    final items = await controller.callAsyncJavaScript(
      functionBody: _searchJs,
    );

    for (var element in (items?.value ?? [])) {
      books.add(Book.fromMap(element));
    }

    await webView.dispose();
    return books;
  }

  @override
  Future<BookData> data(Book book) async {
    final webView = await _request(book.url);
    final controller = webView.webViewController;

    final items = await controller.callAsyncJavaScript(
      functionBody: _bookJs,
      arguments: {'bookId': book.id},
    );

    await webView.dispose();
    return BookData.fromMap(items?.value);
  }

  @override
  Future<ContentModel> content(Chapter chapter, int index) async {
    final webView = await _request(chapter.url);
    final controller = webView.webViewController;

    final content = await controller.callAsyncJavaScript(
      functionBody: _contentJs,
      arguments: {
        'chapterId': chapter.id,
        'index': index,
        'chapterName': chapter.name,
      },
    );

    await webView.dispose();
    return ContentModel.fromMap(content?.value);
  }

  Future<HeadlessInAppWebView> _request(String url) async {
    final completer = Completer<HeadlessInAppWebView>();

    final timer = Timer(const Duration(seconds: 20), () {
      completer.completeError('');
    });

    bool onRandom = false;

    final webView = HeadlessInAppWebView(
      initialUrlRequest: URLRequest(url: Uri.parse(url)),
      onTitleChanged: (controller, title) async {
        if (title != null && title.contains('Random')) onRandom = true;
      },
    );

    webView.onLoadStop = (controller, url) async {
      if (onRandom) {
        timer.cancel();
        completer.complete(webView);
      }
    };

    await webView.run();
    return completer.future;
  }

  String get _lastAddedJs => """
  $getImageJs

  async function getLatestAdded() {
    const books = [];
    const items = document.querySelectorAll("#loop-content .page-item-detail");

    for (const item of items) {
      const a = item.querySelector("h3 a");
      const img = item.querySelector("img");

      if (!a || !img) continue;

      const url = a.getAttribute("href");
      const name = a.textContent?.trim();
      const imageURL = await getImage(img.getAttribute("data-src"));

      if (url && name && imageURL) books.push({ url, name, imageURL });
    }

    return books;
  }

  return await getLatestAdded();
  """;

  String get _searchJs => """
  $getImageJs

  async function searchResult() {
    const books = [];
    const items = document.querySelectorAll(".c-tabs-item div.row");

    for (const item of items) {
      const a = item.querySelector("h3 a");
      const img = item.querySelector("img");

      if (!a || !img) continue;

      const url = a.getAttribute("href");
      const name = a.textContent?.trim();
      const imageURL = await getImage(img.getAttribute("data-src"));

      if (url && name && imageURL) books.push({ url, name, imageURL });
    }

    return books;
  }

  return await searchResult();
  """;

  String get _bookJs => """
  async function book() {
    const chapters = [];
    const categories = [];

    let elements = document.querySelectorAll('.genres-content a');
    for (const element of elements) {
      const name = element.textContent?.trim();
      if (name) categories.push(name);
    }

    let type = null;
    elements = document.querySelectorAll('.post-content_item');
    for (const element of elements) {
      const key = element.querySelector('h5')?.textContent?.toLowerCase().trim();

      if (key !== 'type') continue;
      type = element.querySelector('.summary-content')?.textContent?.trim();
    }

    const sinopse = document.querySelector('.manga-excerpt')?.textContent?.trim() || '';

    elements = document.querySelectorAll('ul.main li.wp-manga-chapter > a');
    for (const element of elements) {
      const url = element.getAttribute('href');
      const name = element?.textContent?.trim();

      if (url && name) chapters.push({ url, name, bookId });
    }

    return { type, chapters, categories, sinopse };
  }

  return await book();
  """;

  String get _contentJs => """
  $getImageJs

  async function content() {
    const novelContent = document.querySelector('.reading-content .text-left');
    if (novelContent) {
      return {
        id: chapterId,
        index: index,
        name: chapterName,
        text: novelContent.innerHTML?.trim(),
      };
    }

    const sources = [];
    for (const img of document.querySelectorAll('.reading-content img')) {
      let src = img.getAttribute("data-src");
      if (!src) continue;

      src = await getImage(img.getAttribute("data-src"));
      sources.push(src);
    }

    return {
      id: chapterId,
      index: index,
      name: chapterName,
      sources,
    }
  }

  return await content();
  """;
}
