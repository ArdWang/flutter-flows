/// RxList - Reactive List
part of 'rx_types.dart';

/// Reactive List that notifies listeners when modified
class RxList<T> extends Rx<List<T>> {
  RxList([List<T>? initial]) : super(initial ?? <T>[]);

  @override
  set value(List<T> newValue) {
    super.value = List<T>.from(newValue);
  }

  void add(T element) {
    final newList = List<T>.from(value);
    newList.add(element);
    value = newList;
  }

  void addAll(Iterable<T> elements) {
    final newList = List<T>.from(value);
    newList.addAll(elements);
    value = newList;
  }

  void remove(T element) {
    if (value.contains(element)) {
      final newList = List<T>.from(value);
      newList.remove(element);
      value = newList;
    }
  }

  void removeAt(int index) {
    if (index >= 0 && index < value.length) {
      final newList = List<T>.from(value);
      newList.removeAt(index);
      value = newList;
    }
  }

  void removeWhere(bool Function(T element) test) {
    final newList = List<T>.from(value);
    newList.removeWhere(test);
    value = newList;
  }

  void clear() {
    value = [];
  }

  T operator [](int index) => value[index];

  void operator []=(int index, T value) {
    final newList = List<T>.from(this.value);
    newList[index] = value;
    this.value = newList;
  }

  int get length => value.length;

  set length(int newLength) {
    final newList = List<T>.from(this.value);
    newList.length = newLength;
    value = newList;
  }

  bool get isEmpty => value.isEmpty;

  bool get isNotEmpty => value.isNotEmpty;
}

/// RxnList - Nullable Reactive List
class RxnList<T> extends RxList<T?> {
  RxnList([List<T?>? initial]) : super(initial);
}
