part of 'package:anr/repositories/scans/scan_base_repository.dart';

class ReaperRepository extends ScanBaseRepository {
  static final ReaperRepository instance = ReaperRepository._internal();
  factory ReaperRepository() => instance;

  ReaperRepository._internal();

  final baseURL = Uri.parse('https://reaperscans.com');
  final scan = Scan.reaper;

  @override
  Future<List<Book>> lastAdded({bool forceUpdate = false}) async {
    final url = baseURL.replace(path: '/latest/comics');
    final response = await httpRepository.get(url, forceUpdate: forceUpdate);
    final document = parse(response.body);
    final items = <Book>[];

    for (final element in document.querySelectorAll('main div div.grid > div')) {
      final name = ScrapingUtil.getText(element: element, selector: 'p a');
      final path = ScrapingUtil.getURL(element: element, selector: 'a') ?? '';
      final source = ScrapingUtil.getImageSource(element: element, selector: 'a img') ?? '';

      if (name.isEmpty || path.isEmpty || source.isEmpty) continue;

      items.add(Book(name: name, path: path, src: source, scan: scan));
    }

    return items;
  }
}
