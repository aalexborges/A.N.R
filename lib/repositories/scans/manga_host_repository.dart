part of 'package:anr/repositories/scans/scan_base_repository.dart';

class MangaHostRepository extends ScanBaseRepository {
  static final MangaHostRepository instance = MangaHostRepository._internal();
  factory MangaHostRepository() => instance;

  MangaHostRepository._internal();

  final baseURLs = <String>['https://mangahosted.com', 'https://mangahost4.com', 'https://mangahostz.com'];
  final scan = Scan.mangaHost;

  @override
  Future<List<Book>> lastAdded({bool forceUpdate = false}) async {
    final response = await httpRepository.tryGetRequestWithBaseURLs(
      headers: headers,
      baseURLs: baseURLs,
      forceUpdate: forceUpdate,
    );

    final document = parse(response.body);
    final items = <Book>[];

    for (final element in document.querySelectorAll('#dados .lejBC.w-row')) {
      final name = ScrapingUtil.getText(element: element, selector: 'h4 a');
      final path = ScrapingUtil.getURL(element: element, selector: 'h4 a') ?? '';
      final source = ScrapingUtil.getImageSource(element: element, selector: 'img') ?? '';

      final is18 = element.querySelector('.age-18') != null;

      if (is18 || name.isEmpty || path.isEmpty || source.isEmpty) continue;

      items.add(Book(name: name, path: path, src: source, scan: scan));
    }

    return items;
  }

  @override
  Future<List<Book>> search(String value, {bool forceUpdate = false}) async {
    final response = await httpRepository.tryGetRequestWithBaseURLs(
      uri: Uri(path: '/find/$value'),
      headers: headers,
      baseURLs: baseURLs,
      forceUpdate: forceUpdate,
    );

    final document = parse(response.body);
    final items = <Book>[];

    for (final element in document.querySelectorAll('main tr')) {
      final name = ScrapingUtil.getText(element: element, selector: 'h4 a');
      final path = ScrapingUtil.getURL(element: element, selector: 'h4 a') ?? '';
      final source = ScrapingUtil.getImageSource(element: element, selector: 'img') ?? '';

      if (name.isEmpty || path.isEmpty || source.isEmpty) continue;

      items.add(Book(name: name, path: path, src: source, scan: scan));
    }

    return items;
  }

  @override
  Future<BookData> data(Book book, {bool forceUpdate = false}) async {
    final response = await httpRepository.tryGetRequestWithBaseURLs(
      uri: Uri.parse(book.path),
      headers: headers,
      baseURLs: baseURLs,
      forceUpdate: forceUpdate,
    );

    final document = parse(response.body);
    final element = document.body;

    if (element is! Element) throw Exception('Invalid document body');

    final categories = ScrapingUtil.getCategories(element: element, selector: 'div.tags a.tag');
    final sinopse = ScrapingUtil.getSinopse(element: element, selector: 'div.text .paragraph');
    final type = ScrapingUtil.getTypeByTable(
      element,
      selector: 'div.text ul li',
      keySelector: 'strong',
      valueSelector: 'div',
    );

    final chapters = <Chapter>[];

    for (final element in element.querySelectorAll('section div.chapters div.cap')) {
      final url = ScrapingUtil.getURL(element: element, selector: '.tags a') ?? '';
      String name = ScrapingUtil.getText(element: element, selector: 'a[rel]');

      if (url.isEmpty && name.isNotEmpty) continue;

      name = double.tryParse(name) != null ? 'Cap. ${name.padLeft(2, '0')}' : name;

      chapters.add(Chapter(
        id: Chapter.idByName(name),
        url: url,
        name: name,
        webId: book.webID,
      ));
    }

    chapters.sort((a, b) => b.id.compareTo(a.id));
    return BookData(sinopse: sinopse, categories: categories, book: book, chapters: chapters, type: type);
  }

  @override
  Future<Content> content(Chapter chapter) async {
    final response = await httpRepository.tryGetRequestWithBaseURLs(
      uri: Uri.parse(chapter.url),
      headers: headers,
      baseURLs: baseURLs,
    );

    final document = parse(response.body);
    final images = <String>[];
    final key = widget.GlobalObjectKey('${chapter.id}-${DateTime.now().millisecondsSinceEpoch}');

    for (final element in document.querySelectorAll('#slider a img')) {
      final src = ScrapingUtil.getImageSource(element: element) ?? '';
      if (src.isNotEmpty) images.add(src);
    }

    return Content(key: key, title: chapter.name, images: images);
  }

  @override
  Map<String, String>? get headers {
    return {
      'Origin': baseURLs[0],
      'Referer': '${baseURLs[0]}/',
      'accept':
          'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
      'upgrade-insecure-requests': '1',
      'user-agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36',
    };
  }
}
