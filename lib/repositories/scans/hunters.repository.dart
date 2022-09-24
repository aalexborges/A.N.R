part of 'scan.repository.dart';

class HuntersRepository extends ScanRepositoryBase {
  @override
  final String baseURL = 'https://huntersscan.xyz';

  HuntersRepository() {
    _cache = DioCache(url: baseURL);
    _dio = Dio()..interceptors.add(_cache.cache.interceptor);
  }

  @override
  Future<List<Book>> lastAdded() async {
    final items = <Book>[];

    try {
      final response = await _dio.get(baseURL, options: _cache.options);
      final $ = parse(response.data);

      const elementsSelector = '#loop-content .page-item-detail';
      for (Element element in $.querySelectorAll(elementsSelector)) {
        final scraping = ScrapingUtil(element);

        final url = scraping.getURL(selector: 'h3 a');
        final name = scraping.getByText(selector: 'h3 a');
        final type = scraping.getByText(selector: 'span.manga-type');
        final image1 = scraping.getImage(selector: 'img');
        final image2 = scraping.getImage(selector: 'img', bySrcSet: true);

        if (scraping.hasEmpty([url, name, image1])) continue;

        items.add(Book(
          url: url,
          name: name,
          type: type,
          scan: Scans.HUNTERS,
          imageURL: image1,
          imageURL2: image2,
        ));
      }

      return items;
    } catch (_) {
      return items;
    }
  }

  @override
  Future<List<Book>> search(String value) async {
    final books = <Book>[];

    final subKey = '?s=$value&post_type=wp-manga';
    final url = '$baseURL/$subKey';

    _updateCache(url, subKey: subKey);

    final response = await _dio.get(url, options: _cache.options);
    final $ = parse(response.data);

    for (Element element in $.querySelectorAll('.c-tabs-item div.row')) {
      final scraping = ScrapingUtil(element);

      final url = scraping.getURL(selector: 'h3 a');
      final name = scraping.getByText(selector: 'h3 a');
      final image1 = scraping.getImage(selector: 'img');
      final image2 = scraping.getImage(selector: 'img', bySrcSet: true);

      if (scraping.hasEmpty([url, name, image1])) continue;

      books.add(Book(
        url: url,
        name: name,
        scan: Scans.HUNTERS,
        imageURL: image1,
        imageURL2: image2,
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

    $.querySelectorAll('.genres-content a').forEach((element) {
      final category = element.text.trim();
      if (category.isNotEmpty) categories.add(category);
    });

    // Type ----------------------------------------------------

    String? type;

    $.querySelectorAll('.post-content_item').forEach((element) {
      final scraping = ScrapingUtil(element);
      final key = scraping.getByText(selector: 'h5').toLowerCase();

      if (key == 'tipo') {
        type = scraping.getByText(selector: '.summary-content');
      }
    });

    // Sinopse -------------------------------------------------

    final sinopse = $.querySelector('.summary__content')?.text.trim() ?? '';

    // Chapters ------------------------------------------------

    final chapters = <Chapter>[];

    try {
      final String cURL = '${book.url}/ajax/chapters'.replaceAll('//a', '/a');
      final cache = DioCache(url: cURL, subKey: cURL);

      final response = await _dio.post(cURL, options: cache.cacheOptions);
      final $ = parse(response.data);

      const chaptersSelector = 'ul.main > li.wp-manga-chapter > a';
      $.querySelectorAll(chaptersSelector).forEach((element) {
        final scraping = ScrapingUtil(element);

        final url = scraping.getURL();
        final name = scraping.getByText();

        if (!scraping.hasEmpty([url, name])) {
          chapters.add(Chapter(url: url, name: name, bookId: book.id));
        }
      });
    } catch (_) {}

    return BookData(
      categories: categories,
      chapters: chapters,
      sinopse: sinopse,
      type: type,
    );
  }

  @override
  Future<ContentModel> content(Chapter chapter, int index) async {
    _updateCache(chapter.url, subKey: chapter.url);

    final response = await _dio.get(chapter.url, options: _cache.options);
    final $ = parse(response.data);

    final novelContent = $.querySelector('.reading-content .text-left');
    if (novelContent != null) {
      return ContentModel(
        id: chapter.id,
        index: index,
        name: chapter.name,
        text: novelContent.innerHtml,
      );
    }

    final sources = <String>[];
    for (Element img in $.querySelectorAll('.reading-content img')) {
      final source = ScrapingUtil(img).getImage();
      if (source.isNotEmpty) sources.add(source);
    }

    return ContentModel(
      id: chapter.id,
      index: index,
      name: chapter.name,
      sources: sources,
    );
  }
}
