/// Rx Types - Reactive value types
library;

import 'package:flutter/foundation.dart';
import '../state_manager/flx.dart' show flxTrack;

part 'rx_list.dart';
part 'rx_map.dart';

/// Base interface for reactive types
abstract class RxInterface<T> extends ValueListenable<T> {
  @override
  T get value;
  set value(T newValue);
}

/// Base Rx class that manages all the stream logic for any Type.
class Rx<T> extends ValueNotifier<T> implements RxInterface<T> {
  Rx(super.initial);

  @override
  T get value {
    // Register with current Flx if tracking is active
    flxTrack(this);
    return super.value;
  }

  @override
  set value(T newValue) {
    super.value = newValue;
  }

  /// Uses a callback to update [value] internally
  void update(T Function(T? val) fn) {
    value = fn(value);
  }

  /// Trigger a rebuild even if the value is the same
  void trigger(T v) {
    value = v;
  }

  @override
  String toString() => value.toString();

  /// Returns the json representation of [value].
  dynamic toJson() {
    try {
      return (value as dynamic)?.toJson();
    } on Exception catch (_) {
      throw '$T has not method [toJson]';
    }
  }
}

/// Nullable Rx class
class Rxn<T> extends Rx<T?> {
  Rxn([super.initial]);
}

/// RxBool for boolean values
class RxBool extends Rx<bool> {
  RxBool(super.initial);

  @override
  String toString() => value ? "true" : "false";
}

/// RxnBool for nullable boolean values
class RxnBool extends Rx<bool?> {
  RxnBool([super.initial]);

  @override
  String toString() => "$value";
}

/// RxInt for integer values
class RxInt extends Rx<int> {
  RxInt(super.initial);
}

/// RxnInt for nullable integer values
class RxnInt extends Rx<int?> {
  RxnInt([super.initial]);
}

/// RxDouble for double values
class RxDouble extends Rx<double> {
  RxDouble(super.initial);
}

/// RxnDouble for nullable double values
class RxnDouble extends Rx<double?> {
  RxnDouble([super.initial]);
}

/// RxString for string values
class RxString extends Rx<String> {
  RxString(super.initial);
}

/// RxnString for nullable string values
class RxnString extends Rx<String?> {
  RxnString([super.initial]);
}

// Extensions for easy .obs creation
extension StringExtension on String {
  RxString get obs => RxString(this);
}

extension IntExtension on int {
  RxInt get obs => RxInt(this);
}

extension DoubleExtension on double {
  RxDouble get obs => RxDouble(this);
}

extension BoolExtension on bool {
  RxBool get obs => RxBool(this);
}

extension RxT<T extends Object> on T {
  Rx<T> get obs => Rx<T>(this);
}

/// New extension to avoid conflicts with dart 3 features
extension RxTnew on Object {
  Rx<T> obs<T>() => Rx<T>(this as T);
}

// Extensions for RxBool
extension RxBoolExt on Rx<bool> {
  bool get isTrue => value;
  bool get isFalse => !isTrue;
  bool operator &(bool other) => other && value;
  bool operator |(bool other) => other || value;
  bool operator ^(bool other) => !other == value;

  /// Toggles the bool value between false and true
  void toggle() {
    value = !value;
  }
}

extension RxnBoolExt on Rx<bool?> {
  bool? get isTrue => value;
  bool? get isFalse {
    if (value != null) return !isTrue!;
    return null;
  }

  bool? operator &(bool other) {
    if (value != null) {
      return other && value!;
    }
    return null;
  }

  bool? operator |(bool other) {
    if (value != null) {
      return other || value!;
    }
    return null;
  }

  /// Toggles the bool value between false and true
  void toggle() {
    if (value != null) {
      value = !value!;
    }
  }
}

// Extensions for RxNum
extension RxNumExt on Rx<num> {
  num operator +(num other) => value + other;
  num operator -(num other) => value - other;
  num operator *(num other) => value * other;
  num operator /(num other) => value / other;
  num operator %(num other) => value % other;

  void increment([num by = 1]) {
    value = value + by;
  }

  void decrement([num by = 1]) {
    value = value - by;
  }
}
