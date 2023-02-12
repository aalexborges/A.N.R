import 'package:anr/repositories/scan_base_repository.dart';

enum Scan {
  neox,
  random,
  glorious,
  prisma,
  reaper,
  olympus,
  mangaHost,
  muitoManga,
  mangaLivre,
  hunters,
}

extension ScansExtension on Scan {
  String get value {
    switch (this) {
      case Scan.neox:
        return 'neox';
      case Scan.random:
        return 'random';
      case Scan.glorious:
        return 'glorious';
      case Scan.prisma:
        return 'prisma';
      case Scan.reaper:
        return 'reaper';
      case Scan.olympus:
        return 'olympus';
      case Scan.mangaHost:
        return 'mangaHost';
      case Scan.muitoManga:
        return 'muitoManga';
      case Scan.mangaLivre:
        return 'mangaLivre';
      case Scan.hunters:
        return 'hunters';
    }
  }

  ScanBaseRepository get repository {
    switch (this) {
      case Scan.neox:
        return NeoxRepository();
      case Scan.random:
        return NeoxRepository();
      case Scan.glorious:
        return NeoxRepository();
      case Scan.prisma:
        return NeoxRepository();
      case Scan.reaper:
        return NeoxRepository();
      case Scan.olympus:
        return NeoxRepository();
      case Scan.mangaHost:
        return NeoxRepository();
      case Scan.muitoManga:
        return NeoxRepository();
      case Scan.mangaLivre:
        return NeoxRepository();
      case Scan.hunters:
        return NeoxRepository();
    }
  }
}

Scan scanByValue(String value) {
  return Scan.values.singleWhere((scan) => scan.value.toLowerCase() == value.toLowerCase().trim());
}
