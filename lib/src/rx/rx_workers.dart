/// Rx Workers - Workers for reactive operations
library;

import 'dart:async';
import 'package:flutter/material.dart';
import '../rx/rx_types.dart';

typedef WorkerCallback<T> = void Function(T value);

/// Worker class to manage reactive subscriptions
class Worker {
  Worker(this._cancel);

  final VoidCallback _cancel;
  bool _disposed = false;

  bool get disposed => _disposed;

  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _cancel();
  }

  void call() => dispose();
}

/// Workers container to manage multiple workers
class Workers {
  final List<Worker> _workers = [];

  void add(Worker worker) {
    _workers.add(worker);
  }

  void dispose() {
    for (final worker in _workers) {
      if (!worker.disposed) {
        worker.dispose();
      }
    }
    _workers.clear();
  }
}

/// Create workers container
Workers workers() => Workers();

bool _checkCondition(dynamic condition) {
  if (condition == null) return true;
  if (condition is bool) return condition;
  if (condition is bool Function()) return condition();
  return true;
}

/// Executes a callback every time the value of [observable] changes.
///
/// Sample:
/// ```dart
/// final count = 0.obs;
/// Worker worker;
///
/// void onInit() {
///   worker = ever(count, (value) {
///     print('counter changed to: $value');
///   }, condition: () => count > 5);
/// }
/// ```
Worker ever<T>(
  RxInterface<T> observable,
  WorkerCallback<T> callback, {
  dynamic condition,
  Duration? debounce,
}) {
  bool isProcessing = false;

  void listener() {
    if (!_checkCondition(condition)) return;

    if (debounce != null) {
      // Debounce logic
      if (!isProcessing) {
        isProcessing = true;
        Timer(debounce, () {
          callback(observable.value);
          isProcessing = false;
        });
      }
    } else {
      if (!isProcessing) {
        isProcessing = true;
        try {
          callback(observable.value);
        } finally {
          isProcessing = false;
        }
      }
    }
  }

  observable.addListener(listener);

  return Worker(() {
    observable.removeListener(listener);
  });
}

/// Executes a callback the first time the value of [observable] changes.
///
/// Sample:
/// ```dart
/// final count = 0.obs;
/// Worker worker;
///
/// void onInit() {
///   worker = once(count, (value) {
///     print('counter first changed to: $value');
///   });
/// }
/// ```
Worker once<T>(
  RxInterface<T> observable,
  WorkerCallback<T> callback, {
  dynamic condition,
}) {
  bool hasExecuted = false;

  void listener() {
    if (hasExecuted) return;

    if (_checkCondition(condition)) {
      hasExecuted = true;
      callback(observable.value);
      // Remove listener after first execution
      observable.removeListener(listener);
    }
  }

  observable.addListener(listener);

  return Worker(() {
    observable.removeListener(listener);
  });
}

/// Executes a callback after [delay] if the value of [observable] doesn't change.
///
/// Sample:
/// ```dart
/// final count = 0.obs;
/// Worker worker;
///
/// void onInit() {
///   worker = interval(count, (value) {
///     print('value after interval: $value');
///   }, delay: Duration(seconds: 1));
/// }
/// ```
Worker interval<T>(
  RxInterface<T> observable,
  WorkerCallback<T> callback, {
  Duration delay = const Duration(seconds: 1),
  dynamic condition,
}) {
  Timer? timer;
  bool isActive = false;

  void listener() {
    if (!_checkCondition(condition)) return;

    if (isActive) return;
    isActive = true;

    timer?.cancel();
    timer = Timer(delay, () {
      callback(observable.value);
      isActive = false;
    });
  }

  observable.addListener(listener);

  return Worker(() {
    timer?.cancel();
    observable.removeListener(listener);
  });
}

/// Executes a callback after [delay] of no changes (debounce).
/// Similar to [interval] but sends the last value after user stops changing it.
///
/// Sample:
/// ```dart
/// final searchQuery = ''.obs;
/// Worker worker;
///
/// void onInit() {
///   worker = debounce(searchQuery, (value) {
///     print('search for: $value');
///   }, time: Duration(milliseconds: 500));
/// }
/// ```
Worker debounce<T>(
  RxInterface<T> observable,
  WorkerCallback<T> callback, {
  Duration time = const Duration(milliseconds: 500),
}) {
  Timer? timer;

  void listener() {
    timer?.cancel();
    timer = Timer(time, () {
      callback(observable.value);
    });
  }

  observable.addListener(listener);

  return Worker(() {
    timer?.cancel();
    observable.removeListener(listener);
  });
}

/// Similar to [ever], but takes a list of observables.
/// The condition is common to all observables.
Worker everAll<T>(
  List<RxInterface<T>> observables,
  WorkerCallback<T> callback, {
  dynamic condition,
}) {
  final List<void Function()> listeners = [];

  for (final obs in observables) {
    void listener() {
      if (_checkCondition(condition)) {
        callback(obs.value);
      }
    }
    obs.addListener(listener);
    listeners.add(listener);
  }

  return Worker(() {
    for (var i = 0; i < observables.length; i++) {
      observables[i].removeListener(listeners[i]);
    }
  });
}

/// Extension on RxInterface for easier worker usage
extension RxWorkerExtension<T> on RxInterface<T> {
  /// Execute callback every time value changes
  Worker onChanged(WorkerCallback<T> callback, {Duration? debounce}) {
    return ever(this, callback, debounce: debounce);
  }

  /// Execute callback only once when value changes
  Worker onFirstChange(WorkerCallback<T> callback) {
    return once(this, callback);
  }
}
