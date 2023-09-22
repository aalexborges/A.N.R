class Chapter {
  Chapter({required this.id, required this.url, required this.name, this.webId});

  final double id;
  final String url;
  final String name;
  final int? webId;

  String get chapterNumber => chapterNumberById(id);

  String get firebaseId {
    final stringId = id.toString().replaceAll('.', '_');
    return id <= 9 ? '0$stringId' : stringId;
  }

  static String chapterNumberById(double id) {
    return id.toStringAsFixed(2).contains('.00') ? id.toStringAsFixed(0) : id.toString();
  }

  static double idByFirebaseId(String firebaseId) => double.parse(firebaseId.replaceAll('_', '.'));

  static double idByName(String name) {
    String value = name.toLowerCase().trim();

    value = value.replaceAll(RegExp(r'cap.'), '').trim();
    value = value.replaceAll(RegExp(r'[^0-9. ]'), '').trim();

    final values = value.split(RegExp(r'[. ]'));
    final beforeFloatPoint = int.parse(values.first);

    if (values.length == 1) return double.parse(beforeFloatPoint.toString());

    final afterFloatPoint = int.tryParse(values[1]);

    if (afterFloatPoint != null) return double.parse('$beforeFloatPoint.$afterFloatPoint');
    return double.parse(beforeFloatPoint.toString());
  }
}

class ContinueReading {
  const ContinueReading({required this.id, required this.progress});

  final double id;
  final double progress;
}
