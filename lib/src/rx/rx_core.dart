/// Rx Core - Base classes for reactive types
library;

import 'dart:async';
import 'package:flutter/foundation.dart';

/// Mixin that provides reactive capabilities
mixin RxObjectMixin<T> on ValueNotifier<T> {
  bool firstRebuild = true;

  /// Makes this Rx looks like a function so you can update a new value
  T call([T? v]) {
    if (v != null) {
      value = v;
    }
    return value;
  }

  /// Returns a StreamSubscription that primes with current value
  StreamSubscription<T> listenAndPump(void Function(T event) onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    // Add listener and immediately trigger with current value
    final subscription = Stream<T>.value(value).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
    return subscription;
  }

  /// Binds an existing Stream<T> to this Rx
  void bindStream(Stream<T> stream) {
    stream.listen((val) => value = val);
  }

  @override
  set value(T val) {
    if (value == val && !firstRebuild) return;
    firstRebuild = false;
    super.value = val;
  }
}
