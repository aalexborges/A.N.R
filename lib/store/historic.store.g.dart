// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'historic.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$HistoricStore on HistoricStoreBase, Store {
  final _$historicAtom = Atom(name: 'HistoricStoreBase.historic');

  @override
  ObservableMap<String, ObservableMap<String, double>> get historic {
    _$historicAtom.reportRead();
    return super.historic;
  }

  @override
  set historic(ObservableMap<String, ObservableMap<String, double>> value) {
    _$historicAtom.reportWrite(value, super.historic, () {
      super.historic = value;
    });
  }

  final _$getAllAsyncAction = AsyncAction('HistoricStoreBase.getAll');

  @override
  Future<void> getAll() {
    return _$getAllAsyncAction.run(() => super.getAll());
  }

  final _$upsertAsyncAction = AsyncAction('HistoricStoreBase.upsert');

  @override
  Future<void> upsert(
      {required String bookId,
      required String chapterId,
      required double read}) {
    return _$upsertAsyncAction.run(
        () => super.upsert(bookId: bookId, chapterId: chapterId, read: read));
  }

  final _$HistoricStoreBaseActionController =
      ActionController(name: 'HistoricStoreBase');

  @override
  void remove({required String bookId, required String chapterId}) {
    final _$actionInfo = _$HistoricStoreBaseActionController.startAction(
        name: 'HistoricStoreBase.remove');
    try {
      return super.remove(bookId: bookId, chapterId: chapterId);
    } finally {
      _$HistoricStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clean() {
    final _$actionInfo = _$HistoricStoreBaseActionController.startAction(
        name: 'HistoricStoreBase.clean');
    try {
      return super.clean();
    } finally {
      _$HistoricStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
historic: ${historic}
    ''';
  }
}
