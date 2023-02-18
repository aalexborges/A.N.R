enum Order { desc, asc }

extension OrderExtension on Order {
  String get value {
    switch (this) {
      case Order.asc:
        return 'ASC';

      case Order.desc:
        return 'DESC';
    }
  }
}
