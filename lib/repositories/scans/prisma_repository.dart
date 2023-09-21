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
}
