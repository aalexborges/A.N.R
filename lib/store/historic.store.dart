import 'package:A.N.R/repositories/historic.repository.dart';
import 'package:mobx/mobx.dart';

part 'historic.store.g.dart';

class HistoricStore = HistoricStoreBase with _$HistoricStore;

typedef HistoricMap = ObservableMap<String, ObservableMap<String, double>>;

abstract class HistoricStoreBase with Store {
  @observable
  HistoricMap historic = ObservableMap();

  @action
  Future<void> getAll() async {
    historic = await HistoricRepository.instance.getAll();
  }

  @action
  Future<void> upsert({
    required String bookId,
    required String chapterId,
    required double read,
  }) async {
    final book = historic[bookId];

    if (book != null) {
      book.update(chapterId, (_) => read, ifAbsent: () => read);
    } else {
      historic[bookId] = ObservableMap()..[chapterId] = read;
    }

    try {
      await HistoricRepository.instance.upsert(
        bookId: bookId,
        chapterId: chapterId,
        read: read,
      );
    } catch (_) {
      remove(bookId: bookId, chapterId: chapterId);
      throw Error();
    }
  }

  @action
  void remove({required String bookId, required String chapterId}) {
    historic[bookId]?.remove(chapterId);
  }

  @action
  void clean() => historic = ObservableMap();
}
