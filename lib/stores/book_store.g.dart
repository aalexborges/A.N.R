// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BookStore on _BookStore, Store {
  Computed<List<Chapter>>? _$chaptersComputed;

  @override
  List<Chapter> get chapters =>
      (_$chaptersComputed ??= Computed<List<Chapter>>(() => super.chapters,
              name: '_BookStore.chapters'))
          .value;

  late final _$dataAtom = Atom(name: '_BookStore.data', context: context);

  @override
  BookData? get data {
    _$dataAtom.reportRead();
    return super.data;
  }

  @override
  set data(BookData? value) {
    _$dataAtom.reportWrite(value, super.data, () {
      super.data = value;
    });
  }

  late final _$pinnedTitleAtom =
      Atom(name: '_BookStore.pinnedTitle', context: context);

  @override
  bool get pinnedTitle {
    _$pinnedTitleAtom.reportRead();
    return super.pinnedTitle;
  }

  @override
  set pinnedTitle(bool value) {
    _$pinnedTitleAtom.reportWrite(value, super.pinnedTitle, () {
      super.pinnedTitle = value;
    });
  }

  late final _$orderAtom = Atom(name: '_BookStore.order', context: context);

  @override
  Order get order {
    _$orderAtom.reportRead();
    return super.order;
  }

  @override
  set order(Order value) {
    _$orderAtom.reportWrite(value, super.order, () {
      super.order = value;
    });
  }

  late final _$getDataAsyncAction =
      AsyncAction('_BookStore.getData', context: context);

  @override
  Future<void> getData(Book book) {
    return _$getDataAsyncAction.run(() => super.getData(book));
  }

  late final _$_BookStoreActionController =
      ActionController(name: '_BookStore', context: context);

  @override
  void setPinnedTitle(bool value) {
    final _$actionInfo = _$_BookStoreActionController.startAction(
        name: '_BookStore.setPinnedTitle');
    try {
      return super.setPinnedTitle(value);
    } finally {
      _$_BookStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleOrder() {
    final _$actionInfo = _$_BookStoreActionController.startAction(
        name: '_BookStore.toggleOrder');
    try {
      return super.toggleOrder();
    } finally {
      _$_BookStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
data: ${data},
pinnedTitle: ${pinnedTitle},
order: ${order},
chapters: ${chapters}
    ''';
  }
}
