import 'package:A.N.R/constants/scans.dart';

class ScanUtil {
  static Scans byValue(String value) {
    return Scans.values.singleWhere(
      (scan) => scan.value.toLowerCase() == value.toLowerCase().trim(),
    );
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
