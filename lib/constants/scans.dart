// ignore_for_file: constant_identifier_names

import 'package:A.N.R/repositories/scans/scan.repository.dart';

enum Scans {
  NEOX,
  RANDOM,
  MARK,
  CRONOS,
  PRISMA,
  REAPER,
  OLYMPUS,
  MANGA_HOST,
  MUITO_MANGA,
  HUNTERS,
}

extension ScansExtension on Scans {
  String get value {
    switch (this) {
      case Scans.NEOX:
        return 'Neox';

      case Scans.RANDOM:
        return 'Random';

      case Scans.MARK:
        return 'Mark';

      case Scans.CRONOS:
        return 'Cronos';

      case Scans.PRISMA:
        return 'Prisma';

      case Scans.REAPER:
        return 'Reaper';

      case Scans.OLYMPUS:
        return 'Olympus';

      case Scans.MANGA_HOST:
        return 'Manga Host';

      case Scans.MUITO_MANGA:
        return 'Muito Mangá';

      case Scans.HUNTERS:
        return 'Hunters';
    }
  }

  ScanRepositoryBase get repository {
    switch (this) {
      case Scans.NEOX:
        return NeoxRepository();

      case Scans.RANDOM:
        return RandomRepository();

      case Scans.MARK:
        return MarkRepository();

      case Scans.CRONOS:
        return CronosRepository();

      case Scans.PRISMA:
        return PrismaRepository();

      case Scans.REAPER:
        return ReaperRepository();

      case Scans.OLYMPUS:
        return OlympusRepository();

      case Scans.MANGA_HOST:
        return MangaHostRepository();

      case Scans.MUITO_MANGA:
        return MuitoMangaRepository();

      case Scans.HUNTERS:
        return HuntersRepository();
    }
  }
}
