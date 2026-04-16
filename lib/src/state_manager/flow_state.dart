/// FlowState - Base class for page state
///
/// Usage:
/// ```dart
/// class HomePageState extends FlowState {
///   final count = 0.obs;
///
///   void increment() => count.value++;
/// }
/// ```
library;

import '../core/lifecycle.dart';

/// Base class for page state
abstract class FlowState with FlowLifeCycleMixin {
  /// Called when the state is created
  @override
  void onInit() {}

  /// Called when the view is ready
  void onReady() {}

  /// Called when the state is closed
  @override
  void onClose() {}
}

/// Base class for reactive state
abstract class RxState extends FlowState {
  /// Reactive state variables should be defined here
  @override
  void onInit() {
    super.onInit();
  }
}
