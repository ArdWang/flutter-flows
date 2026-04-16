/// FlowPage - Route page definition
library;

import 'package:flutter/material.dart';

/// Transition types for page navigation
enum TransitionType {
  fade,
  slideRight,
  slideLeft,
  slideUp,
  slideDown,
  zoom,
  none,
}

/// A page definition for Flow routing
class FlowPage {
  /// The route name
  final String name;

  /// The page builder function
  final Widget Function() page;

  /// Transition type
  final TransitionType transition;

  /// Optional title for the route
  final String? title;

  FlowPage({
    required this.name,
    required this.page,
    this.transition = TransitionType.none,
    this.title,
  });

  /// Creates a MaterialPageRoute for this page
  Route<T> createRoute<T>() {
    return MaterialPageRoute<T>(
      builder: (_) => page(),
      settings: RouteSettings(name: name),
    );
  }

  /// Creates a route with transition animation
  PageRoute<T> createPageRoute<T>() {
    switch (transition) {
      case TransitionType.fade:
        return _createFadeRoute<T>();
      case TransitionType.slideRight:
        return _createSlideRightRoute<T>();
      case TransitionType.slideLeft:
        return _createSlideLeftRoute<T>();
      case TransitionType.slideUp:
        return _createSlideUpRoute<T>();
      case TransitionType.slideDown:
        return _createSlideDownRoute<T>();
      case TransitionType.zoom:
        return _createZoomRoute<T>();
      case TransitionType.none:
        return MaterialPageRoute<T>(
          builder: (_) => page(),
          settings: RouteSettings(name: name),
        );
    }
  }

  PageRouteBuilder<T> _createFadeRoute<T>() {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      settings: RouteSettings(name: name),
    );
  }

  PageRouteBuilder<T> _createSlideRightRoute<T>() {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
      settings: RouteSettings(name: name),
    );
  }

  PageRouteBuilder<T> _createSlideLeftRoute<T>() {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
      settings: RouteSettings(name: name),
    );
  }

  PageRouteBuilder<T> _createSlideUpRoute<T>() {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
      settings: RouteSettings(name: name),
    );
  }

  PageRouteBuilder<T> _createSlideDownRoute<T>() {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, -1.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
      settings: RouteSettings(name: name),
    );
  }

  PageRouteBuilder<T> _createZoomRoute<T>() {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOut),
          ),
          child: child,
        );
      },
      settings: RouteSettings(name: name),
    );
  }
}
