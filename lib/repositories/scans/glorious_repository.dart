part of 'package:anr/repositories/scans/base_scan_repository.dart';

class GloriousRepository extends BaseScanRepository {
  static final GloriousRepository instance = GloriousRepository._internal();
  factory GloriousRepository() => instance;

  GloriousRepository._internal();

  final apiURL = Uri.parse('https://api.gloriousscan.com');
  final baseURL = Uri.parse('https://gloriousscan.com');
  final scan = Scan.glorious;

  @override
  Future<List<BookItem>> lastAdded({forceUpdate = false}) async {
    final response = await httpRepository.get(baseURL, forceUpdate: forceUpdate);
    final document = parse(response.body);
    final items = <BookItem>[];

    for (final element in document.querySelectorAll('div.grid.grid-cols-2 > div')) {
      final name = ScrapingUtil.getText(element: element, selector: 'h5');
      final type = ScrapingUtil.typeByScan(element: element, scan: scan);

      final path = ScrapingUtil.getURL(element: element, selector: 'a') ?? '';
      final source = ScrapingUtil.getImageSource(element: element, selector: 'img') ?? '';

      if (name.isEmpty || path.isEmpty || source.isEmpty) continue;

      items.add(BookItem(name: name, path: path, src: source, type: type, scan: scan));
    }

    return items;
  }

  @override
  Future<List<BookItem>> search(String value, {bool forceUpdate = false}) async {
    if (value.isEmpty) return [];

    final uri = apiURL.replace(path: '/series/search');
    final response = await httpRepository.post(uri, body: {'term': value}, forceUpdate: forceUpdate);
    final data = jsonDecode(response.body);

    final items = <BookItem>[];

    for (final item in data) {
      items.add(BookItem(
        src: item['thumbnail'],
        name: item['title'],
        path: '/series/${item['series_slug']}',
        scan: scan,
      ));
    }

    return items;
  }

  @override
  Future<BookData> data(BookItem bookItem, {bool forceUpdate = false}) async {
    final uri = baseURL.replace(path: bookItem.path);
    final response = await httpRepository.get(uri, forceUpdate: forceUpdate);
    final document = parse(response.body);
    final element = document.body;

    if (element is! Element) throw Exception('Invalid element');

    final type = bookItem.type;
    final sinopse = ScrapingUtil.getSinopse(element: element, selector: '.description-container');
    final chapters = <Chapter>[];

    for (final element in document.querySelectorAll('ul > a')) {
      final url = ScrapingUtil.getURL(element: element) ?? '';
      final name = ScrapingUtil.getText(element: element, selector: 'span');

      if (url.isEmpty && name.isNotEmpty) continue;

      chapters.add(Chapter(id: Chapter.idByName(name), name: name, path: url));
    }

    chapters.sort((a, b) => b.id.compareTo(a.id));
    return BookData(sinopse: sinopse, bookItem: bookItem, categories: [], chapters: chapters, type: type);
  }
}
