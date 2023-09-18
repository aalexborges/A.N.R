part of 'package:anr/repositories/scans/base_scan_repository.dart';

class NeoxRepository extends BaseScanRepository {
  static final NeoxRepository instance = NeoxRepository._internal();
  factory NeoxRepository() => instance;

  NeoxRepository._internal();

  final baseURL = Uri.parse('https://neoxscans.net');
  final scan = Scan.neox;

  @override
  Future<List<BookItem>> lastAdded({forceUpdate = false}) async {
    final response = await httpRepository.get(baseURL, forceUpdate: forceUpdate);
    return ScrapingUtil.genericLastAdd(document: parse(response.body), scan: scan);
  }

  @override
  Future<List<BookItem>> search(String value, {bool forceUpdate = false}) async {
    if (value.isEmpty) return [];

    final uri = baseURL.replace(query: 's=$value&post_type=wp-manga');
    final response = await httpRepository.get(uri, forceUpdate: forceUpdate);

    return ScrapingUtil.genericSearch(document: parse(response.body), scan: scan);
  }

  @override
  Future<BookData> data(BookItem bookItem, {bool forceUpdate = false}) async {
    final uri = Uri.parse(bookItem.path);
    final chapterUri = uri.replace(path: '${uri.path}ajax/chapters');

    final response = await httpRepository.get(uri, forceUpdate: forceUpdate);
    final chapterResponse = await httpRepository.post(
      chapterUri,
      forceUpdate: forceUpdate,
      headers: {"x-requested-with": "XMLHttpRequest"},
    );

    return ScrapingUtil.genericData(
      bookItem: bookItem,
      document: parse(response.body),
      chapterDocument: parse(chapterResponse.body),
    );
  }

  @override
  Future<Content> content(Chapter chapter) async {
    final response = await httpRepository.get(Uri.parse(chapter.path));
    return ScrapingUtil.genericContent(document: parse(response.body), title: chapter.name);
  }
}
