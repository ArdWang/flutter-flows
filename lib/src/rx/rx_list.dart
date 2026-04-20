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

  void removeLast() {
    if (value.isNotEmpty) {
      final newList = List<T>.from(value);
      newList.removeLast();
      value = newList;
    }
  }

  void removeWhere(bool Function(T element) test) {
    final newList = List<T>.from(value);
    newList.removeWhere(test);
    value = newList;
  }

  void retainWhere(bool Function(T element) test) {
    final newList = List<T>.from(value);
    newList.retainWhere(test);
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

  T get first => value.first;

  T get last => value.last;

  int indexOf(T element) => value.indexOf(element);

  bool contains(T element) => value.contains(element);

  /// Returns the first element that satisfies [test], or null if none found
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final element in value) {
      if (test(element)) return element;
    }
    return null;
  }

  /// Returns the last element that satisfies [test], or null if none found
  T? lastWhereOrNull(bool Function(T element) test) {
    for (var i = value.length - 1; i >= 0; i--) {
      if (test(value[i])) return value[i];
    }
    return null;
  }

  /// Returns a new list with the results of calling [mapFn] on each element
  RxList<R> map<R>(R Function(T element) mapFn) {
    return RxList<R>(value.map(mapFn).toList());
  }

  /// Returns a new list with elements that satisfy [test]
  RxList<T> where(bool Function(T element) test) {
    return RxList<T>(value.where(test).toList());
  }

  /// Sorts the list
  void sort([int Function(T a, T b)? compare]) {
    final newList = List<T>.from(value);
    newList.sort(compare);
    value = newList;
  }

  /// Reverses the list
  void reversed() {
    final newList = List<T>.from(value);
    value = newList.reversed.toList();
  }

  /// Adds an element only if it's not null
  void addNonNull(T element) {
    if (element != null) {
      add(element);
    }
  }

  /// Adds an element only if [condition] is true
  void addIf(bool condition, T element) {
    if (condition) {
      add(element);
    }
  }

  /// Adds all elements only if [condition] is true
  void addAllIf(bool condition, Iterable<T> elements) {
    if (condition) {
      addAll(elements);
    }
  }

  /// Replaces all existing items with [item]
  void assign(T item) {
    clear();
    add(item);
  }

  /// Replaces all existing items with [items]
  void assignAll(Iterable<T> items) {
    clear();
    addAll(items);
  }
}

/// RxnList - Nullable Reactive List
class RxnList<T> extends RxList<T?> {
  RxnList([List<T?>? initial]) : super(initial);
}
