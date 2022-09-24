part of 'scan.repository.dart';

class MuitoMangaRepository extends ScanRepositoryBase {
  @override
  final String baseURL = 'https://muitomanga.com';

  MuitoMangaRepository() {
    _cache = DioCache(url: baseURL);
    _dio = Dio()..interceptors.add(_cache.cache.interceptor);
  }

  @override
  Future<List<Book>> lastAdded() async {
    final items = <Book>[];

    try {
      final response = await _dio.get(baseURL, options: _cache.options);
      final $ = parse(response.data);

      for (Element element in $.querySelectorAll('#loadnews_here > div')) {
        final scraping = ScrapingUtil(element);

        final url = baseURL + scraping.getURL(selector: 'a');
        final name = scraping.getByAttribute(selector: 'img', by: 'title');
        final image1 = scraping.getImage(selector: 'img');

        if (scraping.hasEmpty([url, name, image1])) continue;

        items.add(Book(
          url: url,
          name: name,
          scan: Scans.MUITO_MANGA,
          imageURL: image1,
        ));
      }

      return items;
    } catch (e) {
      return items;
    }
  }

  @override
  Future<List<Book>> search(String value) async {
    final books = <Book>[];

    final subKey = '?q=$value';
    final url = '$baseURL/buscar$subKey';

    _updateCache(url, subKey: subKey);

    final response = await _dio.get(url, options: _cache.options);
    final $ = parse(response.data);

    for (Element element in $.querySelectorAll('.content_post > div')) {
      final scraping = ScrapingUtil(element);

      final url = baseURL + scraping.getURL(selector: 'a');
      final name = scraping.getByAttribute(selector: 'img', by: 'title');
      final image1 = scraping.getImage(selector: 'img');

      if (scraping.hasEmpty([url, name, image1])) continue;

      books.add(Book(
        url: url,
        name: name,
        scan: Scans.MUITO_MANGA,
        imageURL: image1,
      ));
    }

    return books;
  }

  @override
  Future<BookData> data(Book book) async {
    _updateCache(book.url, subKey: book.url);

    final response = await _dio.get(book.url, options: _cache.options);
    final $ = parse(response.data);

    // Categories ----------------------------------------------

    final categories = <String>[];

    $.querySelectorAll('ul.last-generos-series > li > a').forEach((element) {
      final category = element.text.trim();
      if (category.isNotEmpty) categories.add(category);
    });

    // Sinopse -------------------------------------------------

    const sinopseSelector = '.boxAnimeSobreLast > p';
    final sinopse = $.querySelector(sinopseSelector)?.text.trim() ?? '';

    // Chapters ------------------------------------------------

    final chapters = <Chapter>[];

    $.querySelectorAll('.manga-chapters > div > a').forEach((element) {
      final scraping = ScrapingUtil(element);

      final url = baseURL + scraping.getURL();
      final name = scraping.getByText().replaceAll('#', '').trim();

      if (!scraping.hasEmpty([url, name])) {
        chapters.add(Chapter(url: url, name: name, bookId: book.id));
      }
    });

    return BookData(
      categories: categories,
      chapters: chapters,
      sinopse: sinopse,
    );
  }

  @override
  Future<ContentModel> content(Chapter chapter, int index) async {
    _updateCache(chapter.url, subKey: chapter.url);

    final response = await _dio.get(chapter.url, options: _cache.options);

    final exp = RegExp(r'"(https:.*?)"');
    final matches = exp.allMatches(response.data);

    final sources = <String>[];

    for (final RegExpMatch m in matches) {
      final String item = m[0].toString().replaceAll('\\/', '/');

      if (item.contains('imgs/')) sources.add(item.replaceAll('"', ''));
    }

    return ContentModel(
      id: chapter.id,
      index: index,
      name: chapter.name,
      sources: sources,
    );
  }
}
