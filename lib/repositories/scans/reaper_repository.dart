part of 'package:anr/repositories/scans/base_scan_repository.dart';

class ReaperRepository extends BaseScanRepository {
  static final ReaperRepository instance = ReaperRepository._internal();
  factory ReaperRepository() => instance;

  ReaperRepository._internal();

  final baseURL = Uri.parse('https://reaperscans.com');
  final scan = Scan.reaper;

  @override
  Future<List<BookItem>> lastAdded({forceUpdate = false}) async {
    final url = baseURL.replace(path: '/latest/comics');
    final response = await httpRepository.get(url, forceUpdate: forceUpdate);
    final document = parse(response.body);
    final items = <BookItem>[];

    for (final element in document.querySelectorAll('main div div.grid > div')) {
      final name = ScrapingUtil.getText(element: element, selector: 'p a');
      final path = ScrapingUtil.getURL(element: element, selector: 'a') ?? '';
      final source = ScrapingUtil.getImageSource(element: element, selector: 'a img') ?? '';

      if (name.isEmpty || path.isEmpty || source.isEmpty) continue;

      items.add(BookItem(name: name, path: path, src: source, scan: scan));
    }

    return items;
  }
}
