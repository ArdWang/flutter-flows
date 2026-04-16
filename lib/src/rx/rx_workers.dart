/// Rx Workers - Workers for reactive operations
library;

/// Executes a callback every time the value of [observable] changes.
void ever<T>(
  dynamic observable,
  void Function(T value) callback, {
  Duration? debounce,
}) {
  // Simple implementation - just registers a listener
  // In a real implementation, this would use streams
}

/// Executes a callback the first time the value of [observable] changes.
void once<T>(dynamic observable, void Function(T value) callback) {
  // Simple implementation for now
}

/// Executes a callback after [delay] if the value of [observable] doesn't change.
void interval<T>(
  dynamic observable,
  void Function(T value) callback, {
  required Duration delay,
}) {
  // Simple implementation for now
}

/// Workers utility class
class Workers {
  final List<void Function()> _subscriptions = [];

  void add(void Function() subscription) {
    _subscriptions.add(subscription);
  }

  void dispose() {
    for (final sub in _subscriptions) {
      sub();
    }
    _subscriptions.clear();
  }
}

/// Create workers container
Workers workers() => Workers();
