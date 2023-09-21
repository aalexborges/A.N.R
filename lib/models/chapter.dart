import 'package:flutter/material.dart';

class Chapter extends ChangeNotifier {
  Chapter({required this.id, required this.url, required this.name, required this.bookSlug, this.webId});

  final double id;
  final String url;
  final String name;
  final String bookSlug;
  final int? webId;

  double _readingProgress = 0;

  String get chapter => chapterNumberById(id);

  String get firebaseId {
    final stringId = id.toString().replaceAll('.', '_');
    return id <= 9 ? '0$stringId' : stringId;
  }

  double get readingProgress => _readingProgress;

  void setReadingProgress(double value) {
    _readingProgress = value;
    notifyListeners();
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
