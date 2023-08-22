import 'package:anr/repositories/scans/base_scan_repository.dart';

enum Scan {
  neox,
  random,
  prisma,
  reaper,
  mangaHost,
  mangaLivre,
  hunters;

  static Scan fromString(String value) {
    return Scan.values.singleWhere((scan) => scan.value == value.toLowerCase().trim());
  }

  static bool isOldScan(String value) {
    return Scan.oldScans.where((element) => element == value.toLowerCase()).isNotEmpty;
  }

  static const oldScans = ['muito manga'];

  static BaseScanRepository repositoryBy(Scan scan) {
    switch (scan) {
      case Scan.neox:
        return NeoxRepository.instance;
      case Scan.random:
        return RandomRepository.instance;
      case Scan.prisma:
        return PrismaRepository.instance;
      case Scan.reaper:
        return ReaperRepository.instance;
      case Scan.mangaHost:
        return MangaHostRepository.instance;
      case Scan.mangaLivre:
        return MangaLivreRepository.instance;
      case Scan.hunters:
        return HuntersRepository.instance;
    }
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

  BaseScanRepository get repository => Scan.repositoryBy(this);
}
