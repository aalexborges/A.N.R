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
        return 'manga host';
      case Scan.muitoManga:
        return 'muito manga';
      case Scan.mangaLivre:
        return 'manga livre';
      case Scan.hunters:
        return 'hunters';
    }
  }

  ScanBaseRepository get repository {
    switch (this) {
      case Scan.neox:
        return NeoxRepository();
      case Scan.random:
        return RandomRepository();
      case Scan.glorious:
        return GloriousRepository();
      case Scan.prisma:
        return PrismaRepository();
      case Scan.reaper:
        return ReaperRepository();
      case Scan.olympus:
        return OlympusRepository();
      case Scan.mangaHost:
        return MangaHostRepository();
      case Scan.muitoManga:
        return MuitoMangaRepository();
      case Scan.mangaLivre:
        return MangaLivreRepository();
      case Scan.hunters:
        return HuntersRepository();
    }
  }
}

Scan scanByValue(String value) {
  return Scan.values.singleWhere((scan) => scan.value.toLowerCase() == value.toLowerCase().trim());
}
