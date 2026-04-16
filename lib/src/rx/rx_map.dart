/// RxMap - Reactive Map
part of 'rx_types.dart';

/// Reactive Map that notifies listeners when modified
class RxMap<K, V> extends Rx<Map<K, V>> {
  RxMap([Map<K, V>? initial]) : super(initial ?? <K, V>{});

  @override
  set value(Map<K, V> newValue) {
    super.value = Map<K, V>.from(newValue);
  }

  void add(K key, V value) {
    final newMap = Map<K, V>.from(this.value);
    newMap[key] = value;
    this.value = newMap;
  }

  void remove(K key) {
    if (value.containsKey(key)) {
      final newMap = Map<K, V>.from(value);
      newMap.remove(key);
      this.value = newMap;
    }
  }

  void clear() {
    value = {};
  }

  V? operator [](K key) => value[key];

  void operator []=(K key, V newValue) {
    final newMap = Map<K, V>.from(value);
    newMap[key] = newValue;
    this.value = newMap;
  }

  bool containsKey(K key) => value.containsKey(key);

  Iterable<K> get keys => value.keys;

  Iterable<V> get values => value.values;

  int get length => value.length;
}

/// RxnMap - Nullable Reactive Map
class RxnMap<K, V> extends RxMap<K, V?> {
  RxnMap([Map<K, V?>? initial]) : super(initial);
}
