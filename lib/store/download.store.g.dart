// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DownloadStore on _DownloadStore, Store {
  final _$chaptersAtom = Atom(name: '_DownloadStore.chapters');

  @override
  ObservableMap<String, bool> get chapters {
    _$chaptersAtom.reportRead();
    return super.chapters;
  }

  @override
  set chapters(ObservableMap<String, bool> value) {
    _$chaptersAtom.reportWrite(value, super.chapters, () {
      super.chapters = value;
    });
  }

  final _$populateAsyncAction = AsyncAction('_DownloadStore.populate');

  @override
  Future<void> populate(String bookId) {
    return _$populateAsyncAction.run(() => super.populate(bookId));
  }

  final _$addInQueueAsyncAction = AsyncAction('_DownloadStore.addInQueue');

  @override
  Future<void> addInQueue(BookDownload book, Chapter chapter) {
    return _$addInQueueAsyncAction.run(() => super.addInQueue(book, chapter));
  }

  final _$removeAsyncAction = AsyncAction('_DownloadStore.remove');

  @override
  Future<void> remove(Chapter chapter) {
    return _$removeAsyncAction.run(() => super.remove(chapter));
  }

  final _$_DownloadStoreActionController =
      ActionController(name: '_DownloadStore');

  @override
  void addFinishedChapter(String chapterId) {
    final _$actionInfo = _$_DownloadStoreActionController.startAction(
        name: '_DownloadStore.addFinishedChapter');
    try {
      return super.addFinishedChapter(chapterId);
    } finally {
      _$_DownloadStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void dispose() {
    final _$actionInfo = _$_DownloadStoreActionController.startAction(
        name: '_DownloadStore.dispose');
    try {
      return super.dispose();
    } finally {
      _$_DownloadStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
chapters: ${chapters}
    ''';
  }
}
