/// Flows Framework Example App
///
/// This example demonstrates all the features of the Flows framework:
/// - Dependency Injection with Flow.put/Flow.find
/// - Reactive state management with Rx types and Flx widget
/// - Route management with Flow.to/Flow.toNamed
/// - Logic/State/View separation pattern
///
/// Supports: Android, iOS, Web, Windows, macOS, Linux
library;

import 'package:flutter/material.dart';
import 'package:flutter_flows/flows.dart';

import 'pages/home_page.dart';
import 'pages/counter_page.dart';
import 'pages/detail_page.dart';

void main() {
  runApp(const FlowsExampleApp());
}

class FlowsExampleApp extends StatelessWidget {
  const FlowsExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FlowMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      pages: [
        FlowPage(name: '/home', page: () => const HomePage()),
        FlowPage(name: '/counter', page: () => const CounterPage()),
        FlowPage(name: '/detail', page: () => const DetailPage()),
      ],
      initialRoute: '/home',
    );
  }
}
