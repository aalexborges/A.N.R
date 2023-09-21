part of 'package:anr/repositories/scans/scan_base_repository.dart';

class GloriousRepository extends ScanBaseRepository {
  static final GloriousRepository instance = GloriousRepository._internal();
  factory GloriousRepository() => instance;

  GloriousRepository._internal();

  final apiURL = Uri.parse('https://api.gloriousscan.com');
  final baseURL = Uri.parse('https://gloriousscan.com');
  final scan = Scan.glorious;

  @override
  Future<List<Book>> lastAdded({bool forceUpdate = false}) async {
    final response = await httpRepository.get(baseURL, forceUpdate: forceUpdate);
    final document = parse(response.body);
    final items = <Book>[];

    for (final element in document.querySelectorAll('div.grid.grid-cols-2 > div')) {
      final name = ScrapingUtil.getText(element: element, selector: 'h5');
      final type = ScrapingUtil.typeByScan(element: element, scan: scan);

      final path = ScrapingUtil.getURL(element: element, selector: 'a') ?? '';
      final source = ScrapingUtil.getImageSource(element: element, selector: 'img') ?? '';

      if (name.isEmpty || path.isEmpty || source.isEmpty) continue;

      items.add(Book(name: name, path: path, src: source, type: type, scan: scan));
    }

    return items;
  }

  @override
  Future<List<Book>> search(String value, {bool forceUpdate = false}) async {
    if (value.isEmpty) return [];

    final uri = apiURL.replace(path: '/series/search');
    final response = await httpRepository.post(uri, body: {'term': value}, forceUpdate: forceUpdate);
    final data = jsonDecode(response.body);

    final items = <Book>[];

    for (final item in data) {
      items.add(Book(
        src: item['thumbnail'],
        name: item['title'],
        path: '/series/${item['series_slug']}',
        scan: scan,
      ));
    }

    return items;
  }
}
