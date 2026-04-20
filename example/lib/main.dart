/// Flows Framework Example App
///
/// This example demonstrates all the features of the Flows framework:
/// - Dependency Injection with Flow.put/Flow.find
/// - Reactive state management with Rx types and Flx widget
/// - Route management with Flow.to/Flow.toNamed
/// - Logic/State/View separation pattern
/// - Light/Dark theme switching
/// - Custom app icon (flows.png)
///
/// Supports: Android, iOS, Web, Windows, macOS, Linux
library;

import 'package:flutter/material.dart' hide Flow;
import 'package:liteflows/flows.dart';

import 'pages/home_page.dart';
import 'pages/counter_page.dart';
import 'pages/detail_page.dart';
import 'pages/perf_test_page.dart';
import 'pages/new_features_page.dart';
import 'utils/pretty_print.dart';

/// App theme colors - Matches the flows.png icon color (cyan/teal)
class AppColors {
  // Primary brand color (extracted from flows.png icon)
  static const Color primary = Color(0xFF26C6DA); // Cyan/Teal from icon
  static const Color primaryLight = Color(0xFF4DD0E1);
  static const Color primaryDark = Color(0xFF0097A7);

  // Secondary colors
  static const Color accent = Color(0xFF00BCD4); // Light cyan
  static const Color success = Color(0xFF00C853);
  static const Color warning = Color(0xFFFFB300);
  static const Color error = Color(0xFFFF5252);

  // White for text on cyan background
  static const Color white = Colors.white;
}

void main() {
  // Print colorful header
  PrettyLogger.header('🚀 FLOWS FRAMEWORK EXAMPLE APP');
  PrettyLogger.info('Initializing application...');
  PrettyLogger.divider('Features');
  PrettyLogger.list([
    'Dependency Injection with Flow.put/Flow.find',
    'Reactive state management with Rx types and Flx widget',
    'Route management with Flow.to/Flow.toNamed',
    'Logic/State/View separation pattern',
    'Light/Dark theme switching',
    'Custom app icon (flows.png)',
  ]);
  PrettyLogger.divider('Supported Platforms');
  PrettyLogger.list([
    'Android',
    'iOS',
    'Web',
    'Windows',
    'macOS',
    'Linux',
  ]);
  PrettyLogger.success('Application ready!');

  runApp(const FlowsExampleApp());
}

/// Global theme controller for the app
class ThemeController {
  static final ThemeController _instance = ThemeController._internal();
  factory ThemeController() => _instance;
  ThemeController._internal();

  final ValueNotifier<ThemeMode> _themeMode = ValueNotifier<ThemeMode>(ThemeMode.system);

  ValueNotifier<ThemeMode> get themeMode => _themeMode;

  ThemeMode get currentMode => _themeMode.value;

  void setThemeMode(ThemeMode mode) {
    PrettyLogger.info('Theme mode set to: $mode');
    _themeMode.value = mode;
  }

  void toggleTheme() {
    final newMode = _themeMode.value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    setThemeMode(newMode);
  }
}

class FlowsExampleApp extends StatefulWidget {
  const FlowsExampleApp({super.key});

  @override
  State<FlowsExampleApp> createState() => _FlowsExampleAppState();
}

class _FlowsExampleAppState extends State<FlowsExampleApp> {
  final _themeController = ThemeController();

  @override
  void initState() {
    super.initState();
    // Print theme info
    PrettyLogger.box('🎨 Theme System Enabled');
    // Listen to theme changes
    _themeController.themeMode.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    _themeController.themeMode.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    setState(() {
      // Rebuild when theme changes
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeController.themeMode,
      builder: (context, themeMode, child) {
        return FlowMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flows Example',
          // Light theme - matches flows.png icon colors
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              brightness: Brightness.light,
              primary: AppColors.primary,
              secondary: AppColors.accent,
            ),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              // Darker cyan for light mode
              backgroundColor: AppColors.primaryDark,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
          // Dark theme - matches flows.png icon colors
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              brightness: Brightness.dark,
              primary: AppColors.primaryLight,
              secondary: AppColors.accent,
            ),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              // Even darker cyan for dark mode
              backgroundColor: Color(0xFF006064),
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
          themeMode: themeMode,
          pages: [
            FlowPage(name: '/home', page: () => const HomePage()),
            FlowPage(name: '/counter', page: () => const CounterPage()),
            FlowPage(name: '/detail', page: () => const DetailPage()),
            FlowPage(name: '/perf-test', page: () => const PerfTestPage()),
            FlowPage(name: '/new-features', page: () => const NewFeaturesPage()),
          ],
          initialRoute: '/home',
        );
      },
    );
  }
}
