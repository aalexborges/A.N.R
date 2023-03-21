import 'package:anr/repositories/scan_base_repository.dart';

enum Scan {
  neox,
  random,
  glorious,
  prisma,
  reaper,
  mode,
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
      case Scan.mode:
        return 'mode';
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
        return const NeoxRepository();
      case Scan.random:
        return const RandomRepository();
      case Scan.glorious:
        return const GloriousRepository();
      case Scan.prisma:
        return const PrismaRepository();
      case Scan.reaper:
        return const ReaperRepository();
      case Scan.mode:
        return const ModeRepository();
      case Scan.mangaHost:
        return const MangaHostRepository();
      case Scan.muitoManga:
        return const MuitoMangaRepository();
      case Scan.mangaLivre:
        return const MangaLivreRepository();
      case Scan.hunters:
        return const HuntersRepository();
    }
  }
}

Scan scanByValue(String value) {
  return Scan.values.singleWhere((scan) => scan.value.toLowerCase() == value.toLowerCase().trim());
}
