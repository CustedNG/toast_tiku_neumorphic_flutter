import '../../core/persistant_store.dart';
import '../../model/tiku_index.dart';

class TikuIndexStore extends PersistentStore<TikuIndexRaw> {
  /// 题库索引数据
  StoreProperty<TikuIndexRaw> get index => property('index');
}
