/// FlowController - Base controller class for state management
library;

import 'package:flutter/foundation.dart';
import '../core/lifecycle.dart';

/// Notifier that supports multiple listeners with optional IDs
class ListNotifier extends ChangeNotifier {
  final Map<Object?, List<VoidCallback>> _listeners = {};

  /// Notifies all listeners or specific group
  void notify({Object? id}) {
    if (id != null && _listeners.containsKey(id)) {
      for (final listener in _listeners[id]!) {
        listener();
      }
    } else {
      notifyListeners();
      // Also notify grouped listeners
      for (final entry in _listeners.entries) {
        for (final listener in entry.value) {
          listener();
        }
      }
    }
  }

  /// Adds a listener with optional group id
  void addListenerId(Object? id, VoidCallback listener) {
    if (!_listeners.containsKey(id)) {
      _listeners[id] = [];
    }
    _listeners[id]!.add(listener);
  }

  /// Removes a listener from group
  void removeListenerId(Object? id, VoidCallback listener) {
    if (_listeners.containsKey(id)) {
      _listeners[id]!.remove(listener);
    }
  }

  /// Refresh all listeners
  void refresh() {
    notifyListeners();
  }

  /// Refresh specific group
  void refreshGroup(Object id) {
    notify(id: id);
  }

  @override
  VoidCallback addListener(VoidCallback listener) {
    addListenerId(null, listener);
    return () => removeListenerId(null, listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    removeListenerId(null, listener);
    // Also remove from grouped listeners
    for (final entry in _listeners.entries) {
      entry.value.remove(listener);
    }
  }
}

/// A base controller class that provides state management functionality.
///
/// Example:
/// ```dart
/// class CounterController extends FlowController {
///   var count = 0;
///
///   void increment() {
///     count++;
///     update(); // Triggers UI update
///   }
/// }
/// ```
abstract class FlowController extends ListNotifier with FlowLifeCycleMixin {
  /// Notifies listeners to update the UI.
  void update([List<Object>? ids, bool condition = true]) {
    if (!condition) return;
    if (ids == null) {
      refresh();
    } else {
      for (final id in ids) {
        refreshGroup(id);
      }
    }
  }
}

/// A base controller class for reactive state management using Rx variables.
///
/// Example:
/// ```dart
/// class UserController extends RxController {
///   final name = 'John'.obs;
///   final age = 30.obs;
/// }
/// ```
abstract class RxController with FlowLifeCycleMixin {}
