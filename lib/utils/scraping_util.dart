import 'package:html/dom.dart';

class ScrapingUtil {
  const ScrapingUtil(this.element);

  final Element element;

  ScrapingUtil? querySelector(String selector) {
    final result = element.querySelector(selector);

    if (result is Element) return ScrapingUtil(result);
    return null;
  }

  String getByAttribute({required String attribute, String? selector}) {
    if (selector is String) return (element.querySelector(selector)?.attributes[attribute] ?? '').trim();
    return (element.attributes[attribute] ?? '').trim();
  }

  String getByText({String? selector}) {
    if (selector is String) return (element.querySelector(selector)?.text ?? '').trim();
    return element.text.trim();
  }

  String getURL({String? selector}) {
    return getByAttribute(attribute: 'href', selector: selector);
  }

  String? getSrc({String? selector, bool? bySrcSet}) {
    final $ = selector is String ? element.querySelector(selector) : element;

    if ($ == null) return '';

    if (bySrcSet == true) {
      final attribute = $.attributes['data-lazy-srcset'] ?? $.attributes['data-srcset'] ?? $.attributes['srcset'];

      if (attribute == null || attribute.contains('no-cover.png')) return null;
      return _bySrcSet(attribute).trim();
    }

    final attribute = $.attributes['data-src'] ?? $.attributes['src'];

    if (attribute == null || attribute.contains('no-cover.png')) return null;
    return attribute.trim();
  }

  bool hasEmptyOrNull(List<String?> values) {
    for (String? value in values) {
      if (value == null || value.isEmpty) return true;
    }

    return false;
  }

  String _bySrcSet(String src) {
    final srcs = '$src,'.replaceAll(RegExp(r'([1-9])\w+,'), '').trim().split(' ');
    return srcs.where((value) => value.length > 3).last.trim();
  }
}

class ScanScrapingUtil {
  const ScanScrapingUtil(this.$);

  final Document $;

  List<String> categories({String? selector}) {
    final categories = <String>[];

    $.querySelectorAll(selector ?? '.genres-content a').forEach((element) {
      final category = element.text.trim();
      if (category.isNotEmpty) categories.add(category);
    });

    return categories;
  }

  String? type({
    String? itemsSelector,
    String? keySelector,
    String? valueSelector,
    String? alternativeType,
    String? Function(String? type)? transform,
  }) {
    String? type;

    $.querySelectorAll(itemsSelector ?? '.post-content_item').forEach((element) {
      final scraping = ScrapingUtil(element);
      final key = scraping.getByText(selector: keySelector ?? 'h5').toLowerCase();

      if (key.contains('tipo') || key.contains('type')) {
        type = scraping.getByText(selector: valueSelector ?? '.summary-content');
        if (transform != null) type = transform(type);
      }
    });

    return (type ?? '').isEmpty ? alternativeType : type;
  }

  String sinopse({String? selector}) {
    return $.querySelector(selector ?? '.manga-excerpt')?.text.trim() ?? '';
  }
}
