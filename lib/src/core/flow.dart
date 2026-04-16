/// Flow - Core dependency injection and navigation
library;

import 'package:flutter/material.dart' hide Flow;
import 'lifecycle.dart';

/// FlowBinding for route-specific dependency injection
abstract class FlowBinding {
  void dependencies();
}

/// Flow - Dependency Injection and Navigation
///
/// Main features:
/// - Dependency Injection with Flow.put/Flow.find
/// - Route management with Flow.to/Flow.toNamed
class Flow {
  static final Map<Type, Map<String?, _InstanceBuilder>> _dependencies = {};
  static final _navigatorKey = GlobalKey<NavigatorState>();

  static GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;
  static NavigatorState? get navigator => _navigatorKey.currentState;

  /// Get current arguments from route settings
  static dynamic get arguments {
    final route = ModalRoute.of(navigator!.context);
    return route?.settings.arguments;
  }

  /// Check if a dependency is registered
  static bool isRegistered<T>({String? tag}) {
    return _dependencies.containsKey(T) && _dependencies[T]!.containsKey(tag);
  }

  /// Register a dependency
  static S put<S>(S dependency, {String? tag, bool permanent = false}) {
    final type = S;
    if (!_dependencies.containsKey(type)) {
      _dependencies[type] = {};
    }
    _dependencies[type]![tag] = _InstanceBuilder(
      instance: dependency,
      permanent: permanent,
    );

    // Call onInit and onReady if it's a controller with lifecycle
    if (dependency is FlowLifeCycleMixin) {
      dependency.init();
      dependency.ready();
    }

    return dependency;
  }

  /// Lazy registration
  static S lazyPut<S>(S Function() builder, {String? tag, bool permanent = false}) {
    final type = S;
    if (!_dependencies.containsKey(type)) {
      _dependencies[type] = {};
    }
    _dependencies[type]![tag] = _InstanceBuilder(
      builder: builder,
      permanent: permanent,
    );
    return find<S>(tag: tag);
  }

  /// Find a dependency
  static S find<S>({String? tag}) {
    final type = S;
    if (!_dependencies.containsKey(type)) {
      throw 'Dependency of type $type not found. Did you forget to call Flow.put()?';
    }
    final builder = _dependencies[type]![tag];
    if (builder == null) {
      throw 'Dependency of type $type with tag $tag not found.';
    }

    if (builder.instance != null) {
      return builder.instance as S;
    }

    if (builder.builder != null) {
      final instance = builder.builder!() as S;
      builder.instance = instance;

      // Call onInit and onReady if it's a controller with lifecycle
      if (instance is FlowLifeCycleMixin) {
        instance.init();
        instance.ready();
      }

      return instance;
    }

    throw 'Dependency of type $type not properly initialized.';
  }

  /// Delete a dependency
  static bool delete<S>({String? tag, bool force = false}) {
    final type = S;
    if (!_dependencies.containsKey(type)) {
      return false;
    }

    final builder = _dependencies[type]![tag];
    if (builder == null) {
      return false;
    }

    if (builder.permanent && !force) {
      return false;
    }

    // Call onClose if it's a controller with lifecycle
    if (builder.instance is FlowLifeCycleMixin) {
      (builder.instance as FlowLifeCycleMixin).close();
    }

    _dependencies[type]!.remove(tag);
    if (_dependencies[type]!.isEmpty) {
      _dependencies.remove(type);
    }
    return true;
  }

  /// Navigate to a page
  static Future<T?> to<T>(Widget page, {FlowBinding? binding}) async {
    if (binding != null) {
      binding.dependencies();
    }
    return navigator?.push<T>(
      MaterialPageRoute<T>(builder: (_) => page),
    );
  }

  /// Navigate to a named route
  static Future<T?> toNamed<T>(String routeName, {Object? arguments}) async {
    return navigator?.pushNamed<T>(routeName, arguments: arguments);
  }

  /// Replace current route
  static Future<T?> off<T>(Widget page, {FlowBinding? binding}) async {
    if (binding != null) {
      binding.dependencies();
    }
    return navigator?.pushReplacement<T, dynamic>(
      MaterialPageRoute<T>(builder: (_) => page),
    );
  }

  /// Replace current route with named route
  static Future<T?> offNamed<T>(String routeName, {Object? arguments}) async {
    return navigator?.pushReplacementNamed<T, dynamic>(routeName, arguments: arguments);
  }

  /// Go back
  static void back<T>([T? result]) {
    navigator?.pop(result);
  }

  /// Go back until a route
  static void backUntil(String routeName) {
    navigator?.popUntil(ModalRoute.withName(routeName));
  }

  /// Remove all routes until the first one
  static void offAll(Widget page, {FlowBinding? binding}) {
    if (binding != null) {
      binding.dependencies();
    }
    navigator?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  /// Remove all routes until the first one with named route
  static void offAllNamed(String routeName, {Object? arguments}) {
    navigator?.pushNamedAndRemoveUntil(routeName, (route) => false, arguments: arguments);
  }
}

/// Internal class for dependency registration
class _InstanceBuilder {
  dynamic instance;
  dynamic Function()? builder;
  final bool permanent;

  _InstanceBuilder({
    this.instance,
    this.builder,
    this.permanent = false,
  });
}
