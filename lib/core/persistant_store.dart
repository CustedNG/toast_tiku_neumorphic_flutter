import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

/// 持久化储存实例
class PersistentStore<E> {
  late Box<E> box;

  Future<PersistentStore<E>> init({String boxName = 'defaultBox'}) async {
    box = await Hive.openBox(boxName);
    return this;
  }

  StoreProperty<T> property<T>(String key, {T? defaultValue}) {
    return StoreProperty<T>(box, key, defaultValue);
  }
}

/// 某属性值储存实例的实现
class StoreProperty<T> {
  StoreProperty(this._box, this._key, this.defaultValue);

  final Box _box;
  final String _key;
  T? defaultValue;

  // 对此[属性值储存实例]，创建一个[可监听的对象]
  ValueListenable<T> listenable() {
    return PropertyListenable<T>(_box, _key, defaultValue);
  }

  /// 获取值
  T? fetch() {
    return _box.get(_key, defaultValue: defaultValue);
  }

  /// 放入/更新，值
  Future<void> put(T value) {
    return _box.put(_key, value);
  }

  /// 删除值
  Future<void> delete() {
    return _box.delete(_key);
  }
}

/// 属性值可监听对象
class PropertyListenable<T> extends ValueListenable<T> {
  PropertyListenable(this.box, this.key, this.defaultValue);

  final Box box;
  final String key;
  T? defaultValue;

  final List<VoidCallback> _listeners = [];
  StreamSubscription? _subscription;

  /// 添加监听者
  @override
  void addListener(VoidCallback listener) {
    _subscription ??= box.watch().listen((event) {
      if (key == event.key) {
        for (var listener in _listeners) {
          listener();
        }
      }
    });

    _listeners.add(listener);
  }

  /// 删除监听者
  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);

    if (_listeners.isEmpty) {
      _subscription?.cancel();
      _subscription = null;
    }
  }

  /// 获取监听的属性的值
  @override
  T get value => box.get(key, defaultValue: defaultValue);
}
