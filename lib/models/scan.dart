import 'package:anr/repositories/scans/scan_base_repository.dart';

enum Scan {
  neox,
  random,
  prisma,
  glorious,
  mangaHost,
  mangaLivre,
  hunters,
  argo;

  static Scan fromString(String value) {
    return Scan.values.singleWhere((scan) => scan.value == value.toLowerCase().trim());
  }

  static bool isOldScan(String value) {
    return Scan.oldScans.where((element) => element == value.toLowerCase()).isNotEmpty;
  }

  static const oldScans = ['reaper', 'muito manga'];

  static ScanBaseRepository repositoryBy(Scan scan) {
    switch (scan) {
      case Scan.neox:
        return NeoxRepository.instance;
      case Scan.random:
        return RandomRepository.instance;
      case Scan.prisma:
        return PrismaRepository.instance;
      case Scan.glorious:
        return GloriousRepository.instance;
      case Scan.mangaHost:
        return MangaHostRepository.instance;
      case Scan.mangaLivre:
        return MangaLivreRepository.instance;
      case Scan.hunters:
        return HuntersRepository.instance;
      case Scan.argo:
        return ArgoRepository.instance;
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
      case Scan.glorious:
        return 'glorious';
      case Scan.mangaHost:
        return 'manga host';
      case Scan.mangaLivre:
        return 'manga livre';
      case Scan.hunters:
        return 'hunters';
      case Scan.argo:
        return 'argo';
    }
  }

  ScanBaseRepository get repository => Scan.repositoryBy(this);
}
