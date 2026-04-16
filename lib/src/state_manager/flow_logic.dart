/// FlowLogic - Base class for business logic
///
/// Usage:
/// ```dart
/// class HomeLogic extends FlowLogic<HomePageState> {
///   @override
///   void onInit() {
///     super.onInit();
///     // Initialize logic
///   }
///
///   void loadData() {
///     // Load data logic
///   }
/// }
/// ```
library;

import '../core/lifecycle.dart';
import 'flow_state.dart';

/// Base class for business logic
abstract class FlowLogic<T extends FlowState> with FlowLifeCycleMixin {
  T? _state;

  /// Get the associated state
  T? get state => _state;

  /// Set the state (should be called by FlowView only)
  void setState(T state) {
    _state = state;
  }

  /// Called when the logic is created
  @override
  void onInit() {}

  /// Called when the logic is ready
  void onReady() {}

  /// Called when the logic is closed
  @override
  void onClose() {}
}
