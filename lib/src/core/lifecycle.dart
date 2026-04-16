/// Lifecycle mixin for controllers - provides onInit, onStart, onReady, onClose callbacks
library;

import 'package:flutter/widgets.dart';

/// Mixin that provides lifecycle callbacks for controllers
mixin FlowLifeCycleMixin {
  /// Called immediately after the controller is created and before it starts being used
  void onInit() {}

  /// Called when the controller is ready to start its work
  void onStart() {}

  /// Called after onInit when the controller and its state are ready
  void onReady() {}

  /// Called when the controller is about to be disposed
  void onClose() {}

  /// Internal flag to track if onInit has been called
  bool _isInitCalled = false;

  /// Internal flag to track if onStart has been called
  bool _isStartCalled = false;

  /// Internal flag to track if onReady has been called
  bool _isReadyCalled = false;

  /// Call this method to trigger onInit lifecycle event
  @mustCallSuper
  void init() {
    if (!_isInitCalled) {
      _isInitCalled = true;
      onInit();
    }
  }

  /// Call this method to trigger onStart lifecycle event
  @mustCallSuper
  void start() {
    if (!_isStartCalled) {
      _isStartCalled = true;
      onStart();
    }
  }

  /// Call this method to trigger onReady lifecycle event
  @mustCallSuper
  void ready() {
    if (!_isReadyCalled) {
      _isReadyCalled = true;
      onReady();
    }
  }

  /// Call this method to trigger onClose lifecycle event
  @mustCallSuper
  void close() {
    onClose();
  }
}
