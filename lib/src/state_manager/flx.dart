/// Flx - A single-level reactive widget
///
/// IMPORTANT: Flx only listens to direct Rx changes in its builder.
/// Flx 设计为单层监听，不支持嵌套 Flx。
///
/// Usage:
/// ```dart
/// final count = 0.obs;
/// Flx(() => Text(count.value.toString()));
/// ```
library;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

typedef WidgetBuilder = Widget Function();

/// Flx widget - Single-level reactive widget
class Flx extends StatefulWidget {
  final WidgetBuilder builder;

  const Flx(this.builder, {super.key});

  @override
  State<Flx> createState() => _FlxState();
}

class _FlxState extends State<Flx> {
  final _listeners = <ValueListenable<dynamic>>[];
  late VoidCallback _rebuildCallback;

  @override
  void initState() {
    super.initState();
    _rebuildCallback = () {
      if (mounted) {
        setState(() {});
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    // Clear old listeners
    _clearListeners();

    // Build and track new listeners
    _trackRxVariables();

    return widget.builder();
  }

  void _trackRxVariables() {
    // Install tracking hook
    _currentTrackingState = this;
    try {
      widget.builder();
    } finally {
      _currentTrackingState = null;
    }
  }

  void _addListener(ValueListenable<dynamic> listenable) {
    if (!_listeners.contains(listenable)) {
      _listeners.add(listenable);
      listenable.addListener(_rebuildCallback);
    }
  }

  void _clearListeners() {
    for (final listenable in _listeners) {
      listenable.removeListener(_rebuildCallback);
    }
    _listeners.clear();
  }

  @override
  void dispose() {
    _clearListeners();
    super.dispose();
  }
}

/// Global tracking state - used by Rx types to register for tracking
_FlxState? _currentTrackingState;

/// Register a ValueListenable with the current Flx widget
void flxTrack(ValueListenable<dynamic> listenable) {
  _currentTrackingState?._addListener(listenable);
}

/// FlxValue - Simple reactive widget for a single Rx value
class FlxValue<T> extends StatelessWidget {
  final ValueListenable<T> data;
  final Widget Function(T value) builder;

  const FlxValue(this.data, this.builder, {super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T>(
      valueListenable: data,
      builder: (context, value, _) => builder(value),
    );
  }
}

/// FlxBuilder - Reactive widget with explicit tracking
class FlxBuilder<T> extends StatelessWidget {
  final ValueListenable<T> observable;
  final Widget Function(T value) builder;

  const FlxBuilder({
    required this.observable,
    required this.builder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T>(
      valueListenable: observable,
      builder: (context, value, _) => builder(value),
    );
  }
}
