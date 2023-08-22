part of 'package:anr/repositories/scans/base_scan_repository.dart';

class HuntersRepository extends BaseScanRepository {
  static final HuntersRepository instance = HuntersRepository._internal();
  factory HuntersRepository() => instance;

  HuntersRepository._internal();

  final baseURL = Uri.parse('https://huntersscan.xyz');
  final scan = Scan.hunters;

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
}
