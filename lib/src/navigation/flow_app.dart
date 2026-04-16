/// FlowApp - Material and Cupertino app widgets with routing
library;

import 'package:flutter/cupertino.dart' hide Flow;
import 'package:flutter/material.dart' hide Flow;
import '../core/flow.dart';
import 'flow_page.dart';

/// FlowMaterialApp - Material app with Flow routing support
class FlowMaterialApp extends StatelessWidget {
  /// The home widget
  final Widget? home;

  /// The initial route
  final String? initialRoute;

  /// All pages for the app
  final List<FlowPage>? pages;

  /// Theme data
  final ThemeData? theme;

  /// Dark theme data
  final ThemeData? darkTheme;

  /// Theme mode
  final ThemeMode? themeMode;

  /// Debug banner enabled
  final bool debugShowCheckedModeBanner;

  /// Custom routes
  final Map<String, Widget Function(BuildContext)>? routes;

  /// Unknown route handler
  final Widget Function(BuildContext)? unknownRoute;

  /// Navigator observers
  final List<NavigatorObserver>? navigatorObservers;

  /// Builder for wrapping the entire app
  final Widget Function(BuildContext, Widget?)? builder;

  const FlowMaterialApp({
    super.key,
    this.home,
    this.initialRoute,
    this.pages,
    this.theme,
    this.darkTheme,
    this.themeMode,
    this.debugShowCheckedModeBanner = true,
    this.routes,
    this.unknownRoute,
    this.navigatorObservers,
    this.builder,
  });

  @override
  Widget build(BuildContext context) {
    // Build page routes
    final Map<String, WidgetBuilder> builtRoutes = {};
    if (pages != null) {
      for (final page in pages!) {
        builtRoutes[page.name] = (_) => page.page();
      }
    }
    if (routes != null) {
      builtRoutes.addAll(routes!);
    }

    return MaterialApp(
      key: key,
      home: home ?? (pages != null && pages!.isNotEmpty ? pages!.first.page() : null),
      initialRoute: initialRoute,
      routes: builtRoutes,
      theme: theme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      navigatorKey: Flow.navigatorKey,
      navigatorObservers: navigatorObservers ?? [],
      builder: builder,
      onGenerateRoute: (settings) {
        if (pages != null) {
          for (final page in pages!) {
            if (page.name == settings.name) {
              return page.createRoute();
            }
          }
        }
        if (unknownRoute != null) {
          return MaterialPageRoute(
            builder: (_) => unknownRoute!(Flow.navigator!.context),
            settings: settings,
          );
        }
        return null;
      },
    );
  }
}

/// FlowCupertinoApp - Cupertino app with Flow routing support
class FlowCupertinoApp extends StatelessWidget {
  final Widget? home;
  final String? initialRoute;
  final List<FlowPage>? pages;
  final bool debugShowCheckedModeBanner;
  final Map<String, Widget Function(BuildContext)>? routes;

  const FlowCupertinoApp({
    super.key,
    this.home,
    this.initialRoute,
    this.pages,
    this.debugShowCheckedModeBanner = true,
    this.routes,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, WidgetBuilder> builtRoutes = {};
    if (pages != null) {
      for (final page in pages!) {
        builtRoutes[page.name] = (_) => page.page();
      }
    }
    if (routes != null) {
      builtRoutes.addAll(routes!);
    }

    return CupertinoApp(
      key: key,
      home: home ?? (pages != null && pages!.isNotEmpty ? pages!.first.page() : null),
      initialRoute: initialRoute,
      routes: builtRoutes,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      navigatorKey: Flow.navigatorKey,
    );
  }
}
