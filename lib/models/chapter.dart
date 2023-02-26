class Chapter {
  const Chapter({required this.id, required this.url, required this.name, required this.bookSlug, this.webId});

  final double id;
  final String url;
  final String name;
  final String bookSlug;

  final String? webId;

  String get chapter {
    return id.toStringAsFixed(2).contains('.00') ? id.toStringAsFixed(0) : id.toString();
  }
}

class ChapterBase {
  const ChapterBase({required this.name, required this.url, required this.bookSlug, this.webId});

  final String url;
  final String name;
  final String bookSlug;

  final String? webId;

  Chapter toChapter() {
    return Chapter(id: _id, url: url, name: name, bookSlug: bookSlug, webId: webId);
  }

  double get _id {
    String value = name.toLowerCase().trim();

    value = value.replaceAll(RegExp(r'cap.'), '').trim();
    value = value.replaceAll(RegExp(r'[^0-9. ]'), '').trim();

    final splitedValue = value.split(RegExp(r'[. ]'));
    final beforeFloatPoint = int.parse(splitedValue.first);

    if (splitedValue.length == 1) return double.parse(beforeFloatPoint.toString());

    final afterFloatPoint = int.tryParse(splitedValue[1]);

    if (afterFloatPoint != null) return double.parse('$beforeFloatPoint.$afterFloatPoint');
    return double.parse(beforeFloatPoint.toString());
  }
}
