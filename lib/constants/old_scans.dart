// ignore_for_file: constant_identifier_names

import 'package:A.N.R/constants/scans.dart';

enum OldScans {
  CRONOS,
}

extension ScansExtension on OldScans {
  String get value {
    switch (this) {
      case OldScans.CRONOS:
        return 'Cronos';
    }
  }

  Scans get current {
    switch (this) {
      case OldScans.CRONOS:
        return Scans.GLORIOUS;
    }
  }
}
