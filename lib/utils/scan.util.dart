import 'package:A.N.R/constants/old_scans.dart';
import 'package:A.N.R/constants/scans.dart';

class ScanUtil {
  static Scans byValue(String value) {
    try {
      return Scans.values.singleWhere((scan) {
        return scan.value.toLowerCase() == value.toLowerCase().trim();
      });
    } catch (_) {
      return OldScans.values.singleWhere((oldScan) {
        return oldScan.value.toLowerCase() == value.toLowerCase().trim();
      }).current;
    }
  }

  static Scans byURL(String url) {
    final regex =
        RegExp(r'^(?:https?:\/\/)?(?:[^@\/\n]+@)?(?:www\.)?([^:\/?\n]+)');

    final String baseURL = regex.firstMatch(url)?.group(1) ?? '';

    return Scans.values.firstWhere((scan) {
      if (scan.repository.baseURL.contains(baseURL)) return true;

      return scan.repository.baseURLs.where((item) {
        return item.contains(baseURL);
      }).isNotEmpty;
    });
  }
}
