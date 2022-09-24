import 'package:html/dom.dart';

class ScrapingUtil {
  final Element element;

  const ScrapingUtil(this.element);

  String getByAttribute({required String by, String? selector}) {
    Element? $ = element;

    if (selector != null) $ = $.querySelector(selector);
    if ($ == null) return '';

    return ($.attributes[by] ?? '').trim();
  }

  String getURL({String? selector}) {
    return getByAttribute(by: 'href', selector: selector);
  }

  String getImage({String? selector, bool? bySrcSet}) {
    Element? $ = element;

    if (selector != null) $ = $.querySelector(selector);
    if ($ == null) return '';

    String src = $.attributes['data-src'] ?? $.attributes['src'] ?? '';

    if (bySrcSet == true) {
      src = $.attributes['data-lazy-srcset'] ??
          $.attributes['data-srcset'] ??
          $.attributes['srcset'] ??
          '';

      src = _bySrcSet(src);
    }

    return src.trim();
  }

  String getByText({Element? root, String? selector}) {
    Element? $ = root ?? element;

    if (selector != null) $ = $.querySelector(selector);
    if ($ == null) return '';

    return $.text.trim();
  }

  bool hasEmpty(List<String> values) {
    for (String value in values) {
      if (value.isEmpty) return true;
    }

    return false;
  }

  Element? getOneByMany({
    required int index,
    required String selector,
    bool Function(Element element)? filter,
  }) {
    List<Element> $ = element.querySelectorAll(selector);

    if (filter != null) $ = $.where(filter).toList();

    return (index < 0 || index > $.length - 1) ? null : $[index];
  }

  String _bySrcSet(String src) {
    return '$src,'
        .replaceAll(RegExp(r'([1-9])\w+,'), '')
        .trim()
        .split(' ')
        .where((value) => value.length > 3)
        .last
        .trim();
  }
}
