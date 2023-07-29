enum Scan {
  neox,
  random,
  prisma,
  reaper,
  mangaHost,
  mangaLivre,
  hunters;

  static Scan fromString(String value) {
    return Scan.values.singleWhere((scan) => scan.value.toLowerCase() == value.toLowerCase().trim());
  }
}

extension ScansExtension on Scan {
  String get value {
    switch (this) {
      case Scan.neox:
        return 'neox';
      case Scan.random:
        return 'random';
      case Scan.prisma:
        return 'prisma';
      case Scan.reaper:
        return 'reaper';
      case Scan.mangaHost:
        return 'manga host';
      case Scan.mangaLivre:
        return 'manga livre';
      case Scan.hunters:
        return 'hunters';
    }
  }
}
