part of 'scan.repository.dart';

String? _validURL;

class MangaHostRepository extends ScanRepositoryBase {
  @override
  final baseURLs = <String>[
    'https://mangahosted.com',
    'https://mangahost4.com',
    'https://mangahostz.com',
  ];

  MangaHostRepository() {
    _cache = DioCache(url: baseURL, options: Options(headers: headers));
    _dio = Dio()..interceptors.add(_cache.cache.interceptor);
  }

  @override
  String get baseURL => _validURL ?? baseURLs[0];

  @override
  Map<String, String> get headers {
    return {
      'Origin': baseURL,
      'Referer': '$baseURL/',
      'accept':
          'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
      'upgrade-insecure-requests': '1',
      'user-agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36',
    };
  }

  @override
  Future<List<Book>> lastAdded() async {
    final items = <Book>[];

    await _tryAllURLs(((url, resolve) async {
      _updateCache(url);

      try {
        final response = await _dio.get(url, options: _cache.cacheOptions);
        if (_isCacheResponse(response)) return;

        final $ = parse(response.data);

        for (Element element in $.querySelectorAll('#dados .lejBC.w-row')) {
          final scraping = ScrapingUtil(element);

          final url = scraping.getURL(selector: 'h4 a');
          final name = scraping.getByText(selector: 'h4 a');
          final image1 = scraping.getImage(selector: 'img');
          final image2 = scraping.getImage(selector: 'source', bySrcSet: true);

          final bool is18 = element.querySelector('.age-18') != null;

          if (scraping.hasEmpty([url, name, image1]) || is18) continue;

          items.add(Book(
            url: url,
            name: name,
            scan: Scans.MANGA_HOST,
            imageURL: image1,
            imageURL2: image2,
          ));
        }

        await resolve();
      } catch (_) {}
    }));

    return items;
  }

  @override
  Future<List<Book>> search(String value) async {
    final books = <Book>[];

    await _tryAllURLs((baseURL, resolve) async {
      final subKey = 'find/$value';
      final url = '$baseURL/$subKey';

      _updateCache(url, subKey: subKey);

      final response = await _dio.get(url, options: _cache.cacheOptions);
      if (_isCacheResponse(response)) return;

      final $ = parse(response.data);

      for (Element element in $.querySelectorAll('main tr')) {
        final scraping = ScrapingUtil(element);

        final url = scraping.getURL(selector: 'h4 a');
        final name = scraping.getByText(selector: 'h4 a');
        final image1 = scraping.getImage(selector: 'img');
        final image2 = scraping.getImage(selector: 'source', bySrcSet: true);

        if (scraping.hasEmpty([url, name, image1])) continue;

        books.add(Book(
          url: url,
          name: name,
          scan: Scans.MANGA_HOST,
          imageURL: image1.isEmpty || image2.isNotEmpty ? image2 : image1,
          imageURL2: image1.isEmpty || image2.isNotEmpty ? image1 : image2,
        ));
      }

      await resolve();
    });

    return books;
  }

  @override
  Future<BookData> data(Book book) async {
    _updateCache(book.url, subKey: book.url);

    final response = await _dio.get(book.url, options: _cache.cacheOptions);
    final $ = parse(response.data);

    // Categories ----------------------------------------------

    final categories = <String>[];

    $.querySelectorAll('div.tags a.tag').forEach((element) {
      final category = element.text.trim();
      if (category.isNotEmpty) categories.add(category);
    });

    // Type ----------------------------------------------------

    String? type;

    $.querySelectorAll('div.text ul li').forEach((element) {
      final scraping = ScrapingUtil(element);
      final key = scraping.getByText(selector: 'strong').toLowerCase();

      if (key == 'tipo:') {
        type = scraping.getByText(selector: 'div');
        type = type!.isEmpty ? null : type!.replaceAll('Tipo: ', '').trim();
      }
    });

    type ??= book.type;

    // Sinopse -------------------------------------------------

    final sinopse = $.querySelector('div.text .paragraph')?.text.trim() ?? '';

    // Chapters ------------------------------------------------

    final chapters = <Chapter>[];

    $.querySelectorAll('section div.chapters div.cap').forEach((element) {
      final scraping = ScrapingUtil(element);

      final url = scraping.getURL(selector: '.tags a');
      String name = scraping.getByText(selector: 'a[rel]');

      if (!scraping.hasEmpty([url, name])) {
        final double? episode = double.tryParse(name);
        name = episode != null ? 'Cap. ${name.padLeft(2, '0')}' : name;

        chapters.add(Chapter(url: url, name: name, bookId: book.id));
      }
    });

    return BookData(
      categories: categories,
      chapters: chapters,
      sinopse: sinopse,
      type: type,
    );
  }

  @override
  Future<Content> content(Chapter chapter, int index) async {
    _updateCache(chapter.url, subKey: chapter.url);

    final response = await _dio.get(chapter.url, options: _cache.cacheOptions);
    final $ = parse(response.data);

    final sources = <String>[];
    for (Element img in $.querySelectorAll('#slider a img')) {
      final source = ScrapingUtil(img).getImage();
      if (source.isNotEmpty) sources.add(source);
    }

    return Content(
      id: chapter.id,
      index: index,
      name: chapter.name,
      sources: sources,
      bookId: chapter.bookId,
    );
  }

  Future<void> _tryAllURLs(
    Future<void> Function(String url, Future<void> Function() resolve) callback,
  ) async {
    for (String url in baseURLs) {
      bool resolve = false;

      try {
        await callback(url, () async {
          _validURL = url;
          resolve = true;
        });
      } catch (_) {}

      if (resolve) break;
    }
  }
}
