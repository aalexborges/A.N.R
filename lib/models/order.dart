enum Order {
  desc,
  asc;

  static int realIndexBy(Order order, int index, int itemsLength) {
    return order == Order.asc ? itemsLength - (index + 1) : index;
  }
}

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
