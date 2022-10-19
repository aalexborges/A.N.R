part of 'scan.repository.dart';

class ReaperRepository extends ScanRepositoryBase {
  @override
  final String baseURL = 'https://reaperscans.net';
  final String apiBaseURL = 'https://api.reaperscans.net';

  @override
  final baseURLs = <String>[
    'https://reaperscans.net',
    'https://reaperscans.com.br',
  ];

  ReaperRepository() {
    _cache = DioCache(url: baseURL);
    _dio = Dio()..interceptors.add(_cache.cache.interceptor);
  }

  @override
  Future<List<Book>> lastAdded() async {
    final items = <Book>[];

    await _tryAllURLs((baseURL, resolve) async {
      _updateCache(baseURL);

      final response = await _dio.get(baseURL, options: _cache.cacheOptions);
      final $ = parse(response.data);

      const elementsSelector = '.container .grid.grid-cols-2 > div';
      for (Element element in $.querySelectorAll(elementsSelector)) {
        final scraping = ScrapingUtil(element);

        final url = scraping.getURL(selector: 'a');
        final name = scraping.getByText(selector: 'h5');
        final image1 = scraping.getImage(selector: 'img');
        final type = scraping.getByText(selector: 'div span');

        if (scraping.hasEmpty([url, name, image1])) continue;

        items.add(Book(
          url: baseURL + url,
          name: name,
          type: type.isEmpty ? null : type,
          scan: Scans.REAPER,
          imageURL: image1,
        ));
      }

      if (items.isNotEmpty) await resolve();
    });

    return items;
  }

  @override
  Future<BookData> data(Book book) async {
    _updateCache(book.url, subKey: book.url);

    final response = await _dio.get(book.url, options: _cache.cacheOptions);
    final $ = parse(response.data);

    // Categories ----------------------------------------------

    final categories = <String>[];

    $.querySelectorAll('.tags-container > span').forEach((element) {
      final category = element.text.trim();
      if (category.isNotEmpty) categories.add(category);
    });

    // Sinopse -------------------------------------------------

    final sinopse =
        $.querySelector('.description-container')?.text.trim() ?? '';

    // Chapters ------------------------------------------------

    final chapters = <Chapter>[];

    $.querySelectorAll('.chapters-list-single > a').forEach((element) {
      final scraping = ScrapingUtil(element);

      final url = scraping.getURL();
      final name = scraping.getByText(selector: 'span.name');

      if (!scraping.hasEmpty([url, name])) {
        chapters.add(Chapter(url: baseURL + url, name: name, bookId: book.id));
      }
    });

    return BookData(
      categories: categories,
      chapters: chapters,
      sinopse: sinopse,
      type: book.type,
    );
  }

  @override
  Future<Content> content(Chapter chapter, int index) async {
    _updateCache(chapter.url, subKey: chapter.url);

    Response response = await _dio.get(
      chapter.url,
      options: _cache.cacheOptions,
    );
    final $ = parse(response.data);

    final item = jsonDecode($.querySelector('#__NEXT_DATA__')?.innerHtml ?? '');
    final id = item['props']['pageProps']['data']['id'];
    final url = '$apiBaseURL/series/chapter/$id';

    _updateCache(url, subKey: id.toString());
    response = await _dio.get(url, options: _cache.cacheOptions);

    final content = response.data['content'];

    if (content is String) {
      return Content(
        id: chapter.id,
        index: index,
        name: chapter.name,
        text: content,
        bookId: chapter.bookId,
      );
    }

    final sources = <String>[];
    for (String src in content['images']) {
      sources.add('$apiBaseURL/$src');
    }

    return Content(
      id: chapter.id,
      index: index,
      name: chapter.name,
      sources: sources,
      bookId: chapter.bookId,
    );
  }
}
