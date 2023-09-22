part of 'package:anr/repositories/scans/scan_base_repository.dart';

class PrismaRepository extends ScanBaseRepository {
  static final PrismaRepository instance = PrismaRepository._internal();
  factory PrismaRepository() => instance;

  PrismaRepository._internal();

  final baseURL = Uri.parse('https://prismascans.net');
  final scan = Scan.prisma;

  @override
  Future<List<Book>> lastAdded({bool forceUpdate = false}) async {
    final response = await httpRepository.get(baseURL, forceUpdate: forceUpdate);
    return ScrapingUtil.genericLastAdd(document: parse(response.body), scan: scan);
  }

  @override
  Future<List<Book>> search(String value, {bool forceUpdate = false}) async {
    if (value.isEmpty) return [];

    final uri = baseURL.replace(query: 's=$value&post_type=wp-manga');
    final response = await httpRepository.get(uri, forceUpdate: forceUpdate);

    return ScrapingUtil.genericSearch(document: parse(response.body), scan: scan);
  }

  @override
  Future<BookData> data(Book book, {bool forceUpdate = false}) async {
    final uri = Uri.parse(book.path);
    final chapterUri = uri.replace(path: '${uri.path}ajax/chapters');

    final response = await httpRepository.get(uri, forceUpdate: forceUpdate);
    final chapterResponse = await httpRepository.post(
      chapterUri,
      forceUpdate: forceUpdate,
      headers: {"x-requested-with": "XMLHttpRequest"},
    );

    return ScrapingUtil.genericData(
      book: book,
      document: parse(response.body),
      chapterDocument: parse(chapterResponse.body),
    );
  }

  @override
  Future<Content> content(Chapter chapter) async {
    final response = await httpRepository.get(Uri.parse(chapter.url));
    return ScrapingUtil.genericContent(id: chapter.id, document: parse(response.body), title: chapter.name);
  }
}
