// ignore_for_file: constant_identifier_names

enum Order { DESC, ASC }

extension OrderExtension on Order {
  String get value {
    switch (this) {
      case Order.ASC:
        return 'ASC';

      case Order.DESC:
        return 'DESC';
    }
  }
}
