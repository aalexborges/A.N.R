// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$BookStore on _BookStore, Store {
  Computed<List<Chapter>>? _$chaptersComputed;

  @override
  List<Chapter> get chapters =>
      (_$chaptersComputed ??= Computed<List<Chapter>>(() => super.chapters,
              name: '_BookStore.chapters'))
          .value;

  final _$isLoadingAtom = Atom(name: '_BookStore.isLoading');

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  final _$pinnedTitleAtom = Atom(name: '_BookStore.pinnedTitle');

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

  final _$orderAtom = Atom(name: '_BookStore.order');

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

  final _$dataAtom = Atom(name: '_BookStore.data');

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

  final _$getDataAsyncAction = AsyncAction('_BookStore.getData');

  @override
  Future<void> getData(Book book) {
    return _$getDataAsyncAction.run(() => super.getData(book));
  }

  final _$_BookStoreActionController = ActionController(name: '_BookStore');

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
isLoading: ${isLoading},
pinnedTitle: ${pinnedTitle},
order: ${order},
data: ${data},
chapters: ${chapters}
    ''';
  }
}
