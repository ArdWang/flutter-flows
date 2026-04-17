# Flows

[![Pub Version](https://img.shields.io/pub/v/liteflows.svg)](https://pub.dev/packages/liteflows)
[![Flutter Version](https://img.shields.io/badge/Flutter-%3E%3D3.3.0-blue.svg)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-%3E%3D3.2.3-blue.svg)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![Style](https://img.shields.io/badge/style-flutter__lints--yellow.svg)](https://pub.dev/packages/flutter_lints)

A lightweight, modern, and powerful Flutter framework that combines **state management**, **dependency injection**, and **route management** in a clean, performant, and easy-to-use API. Inspired by GetX but with a cleaner design focused on performance and simplicity.

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Architecture](#architecture)
- [Core Concepts](#core-concepts)
  - [Dependency Injection](#dependency-injection)
  - [Reactive State Management](#reactive-state-management)
  - [Route Management](#route-management)
- [API Reference](#api-reference)
- [Migration Guide from GetX](#migration-guide-from-getx)
- [Performance Tips](#performance-tips)
- [Example App](#example-app)
- [Acknowledgments](#acknowledgments)
- [License](#license)

## Features

- **Dependency Injection**: Simple and powerful DI with `Flow.put`, `Flow.find`, and `Flow.isRegistered`
- **Reactive State Management**: Ultra-fast reactive programming with `Rx` types and `Flx` widgets
- **Route Management**: Clean navigation with `Flow.to`, `Flow.toNamed`, and `Flow.back`
- **Logic/State/View Pattern**: Clear separation of concerns for maintainable code
- **Zero Boilerplate**: No need for StreamControllers, ChangeNotifiers, or InheritedWidgets
- **Performance Optimized**: Single-level observation design for maximum performance
- **Type-Safe**: Full Dart type system support
- **Multi-Platform**: Works on Android, iOS, Web, Windows, macOS, and Linux

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  liteflows: ^0.0.1
```

Then run:

```bash
flutter pub get
```

Import the package:

```dart
import 'package:flutter_flows/flows.dart';
```

## Quick Start

Here's a complete example of a counter app:

```dart
import 'package:flutter/material.dart';
import 'package:liteflows/liteflows.dart';

// 1. Define State
class CounterState {
  final count = 0.obs;
}

// 2. Define Logic
class CounterLogic extends FlowController {
  CounterLogic() {
    state = CounterState();
  }

  void increment() => state.count.value++;
  void decrement() => state.count.value--;
  void reset() => state.count.value = 0;
}

// 3. Define View
class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Register logic if not already registered
    if (!Flow.isRegistered<CounterLogic>()) {
      Flow.put(CounterLogic());
    }
    final logic = Flow.find<CounterLogic>();

    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Reactive text that updates automatically
            Flx(() => Text(
              'Count: ${logic.state.count.value}',
              style: const TextStyle(fontSize: 32),
            )),
            const SizedBox(height: 32),
            // Buttons with reactive handlers
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: logic.decrement,
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: logic.increment,
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: logic.reset,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 4. Define App
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FlowMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flows Demo',
      pages: [
        FlowPage(name: '/counter', page: () => const CounterPage()),
      ],
      initialRoute: '/counter',
    );
  }
}

void main() {
  runApp(const MyApp());
}
```

## Architecture

Flows uses a **Logic/State/View** architecture pattern that provides clear separation of concerns:

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│    View     │────▶│    Logic    │────▶│    State    │
│  (Widgets)  │◀────│ (Business)  │◀────│   (Data)    │
└─────────────┘     └─────────────┘     └─────────────┘
```

- **State**: Holds reactive data (`Rx` types)
- **Logic**: Contains business logic and state mutations
- **View**: Displays state and dispatches actions to logic

This pattern provides:
- Clear separation of concerns
- Easy testing of business logic
- Reusable state and logic
- Better code organization

## Core Concepts

### Dependency Injection

Flows provides a simple yet powerful dependency injection system:

```dart
// Register a dependency
Flow.put(MyService());

// Register with a name
Flow.put(MyService(), name: 'myService');

// Register as lazy (created on first access)
Flow.putLazy(() => MyService());

// Find a dependency
final service = Flow.find<MyService>();

// Find by name
final service = Flow.find<MyService>(name: 'myService');

// Check if registered
if (Flow.isRegistered<MyService>()) {
  // Do something
}

// Remove a dependency
Flow.remove<MyService>();

// Remove all dependencies
Flow.disposeAll();
```

#### FlowController Lifecycle

`FlowController` provides lifecycle methods:

```dart
class MyLogic extends FlowController {
  @override
  void onInit() {
    super.onInit();
    // Called when controller is created
  }

  @override
  void onClose() {
    // Called when controller is disposed
    super.onClose();
  }
}
```

### Reactive State Management

Flows uses reactive types that automatically update the UI when changed:

```dart
// Define reactive state
class MyState {
  final count = 0.obs;          // Reactive int
  final name = ''.obs;          // Reactive String
  final items = RxList<String>([]); // Reactive List
  final user = Rxn<User>();     // Reactive nullable object
  final config = RxMap();       // Reactive Map
  final isActive = false.obs;   // Reactive bool
}
```

#### Using Flx Widget

The `Flx` widget rebuilds when observed state changes:

```dart
// Full rebuild of widget tree
Flx(() => Text('Count: ${logic.state.count.value}'));

// FlxValue for single value optimization
FlxValue(
  logic.state.count,
  (count) => Text('Count: $count'),
);
```

#### Rx Types

| Type | Description | Example |
|------|-------------|---------|
| `Rx<T>` | Reactive wrapper for any type | `Rx<int>(0)` |
| `Rxn<T>` | Reactive nullable wrapper | `Rxn<User>()` |
| `RxBool` | Reactive bool | `false.obs` |
| `RxInt` | Reactive int | `0.obs` |
| `RxDouble` | Reactive double | `0.0.obs` |
| `RxString` | Reactive String | `''.obs` |
| `RxList<T>` | Reactive List | `RxList<String>([])` |
| `RxMap<K, V>` | Reactive Map | `RxMap()` |
| `RxSet<T>` | Reactive Set | `RxSet()` |

### Route Management

Flows provides simple navigation APIs:

```dart
// Navigate to named route
Flow.toNamed('/detail');

// Navigate with arguments
Flow.toNamed('/detail', arguments: {'id': 123});

// Navigate with custom route
Flow.to(NextPage());

// Navigate with custom route and arguments
Flow.to(NextPage(), arguments: {'data': myData});

// Go back
Flow.back();

// Go back with result
Flow.back({'result': 'success'});

// Replace current route
Flow.off(NextPage());

// Replace all routes
Flow.offAll(NextPage());
```

#### FlowMaterialApp

```dart
FlowMaterialApp(
  debugShowCheckedModeBanner: false,
  title: 'My App',
  // Light theme
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
  ),
  // Dark theme
  darkTheme: ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),
  ),
  themeMode: ThemeMode.system,
  // Define routes
  pages: [
    FlowPage(name: '/home', page: () => HomePage()),
    FlowPage(name: '/detail', page: () => DetailPage()),
  ],
  initialRoute: '/home',
)
```

#### Receiving Route Arguments

**View-level (Recommended):**

```dart
class DetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get arguments from route settings
    final args = ModalRoute.of(context)?.settings.arguments;
    final id = args is Map ? args['id'] as int? : null;
    final data = args is Map ? args['data'] : null;

    // Use id and data...
  }
}
```

## API Reference

### Flow (Dependency Injection)

| Method | Description |
|--------|-------------|
| `Flow.put<T>(instance)` | Register a dependency |
| `Flow.putLazy<T>(factory)` | Register lazy dependency |
| `Flow.find<T>(name)` | Find a dependency |
| `Flow.isRegistered<T>(name)` | Check if registered |
| `Flow.remove<T>(name)` | Remove a dependency |
| `Flow.disposeAll()` | Remove all dependencies |

### FlowController

| Method | Description |
|--------|-------------|
| `onInit()` | Called on controller creation |
| `onClose()` | Called on controller disposal |

### Rx Types

| Constructor | Description |
|-------------|-------------|
| `T.obs` | Extension to create reactive type |
| `Rx<T>(value)` | Create reactive wrapper |
| `Rxn<T>()` | Create nullable reactive wrapper |
| `RxList<T>` constructor | Create reactive List |

### Flx Widgets

| Widget | Description |
|--------|-------------|
| `Flx(builder)` | Reactive widget builder |
| `FlxValue(rx, builder)` | Optimized single-value reactive widget |

### Navigation

| Method | Description |
|--------|-------------|
| `Flow.to(page)` | Navigate to page |
| `Flow.toNamed(name)` | Navigate to named route |
| `Flow.back()` | Go back |
| `Flow.off(page)` | Replace current route |
| `Flow.offAll(page)` | Replace all routes |

## Migration Guide from GetX

Flows is inspired by GetX but with a cleaner API. Here's how to migrate:

### GetX to Flows Migration Table

| GetX | Flows |
|------|-------|
| `Get.put()` | `Flow.put()` |
| `Get.find()` | `Flow.find()` |
| `Get.isRegistered()` | `Flow.isRegistered()` |
| `Get.delete()` | `Flow.remove()` |
| `Get.to()` | `Flow.to()` |
| `Get.toNamed()` | `Flow.toNamed()` |
| `Get.back()` | `Flow.back()` |
| `Get.off()` | `Flow.off()` |
| `Get.offAll()` | `Flow.offAll()` |
| `GetX<Controller>` | `Flx(() => ...)` |
| `Obx(() => ...)` | `Flx(() => ...)` |
| `RxInt`, `RxString`, etc. | Same with `.obs` extension |
| `GetMaterialApp` | `FlowMaterialApp` |
| `GetPage` | `FlowPage` |

### Example Migration

**GetX:**
```dart
class Controller extends GetxController {
  final count = 0.obs;
  void increment() => count.value++;
}

Get.put(Controller());
GetX<Controller>(
  builder: (_) => Text('Count: ${_.count.value}'),
);
```

**Flows:**
```dart
class Controller extends FlowController {
  final count = 0.obs;
  void increment() => count.value++;
}

Flow.put(Controller());
Flx(() => Text('Count: ${logic.state.count.value}'));
```

## Performance Tips

1. **Use FlxValue for single values**: More efficient than full `Flx` rebuilds

```dart
// Less efficient
Flx(() => Text('Count: ${logic.state.count.value}'));

// More efficient
FlxValue(logic.state.count, (count) => Text('Count: $count'));
```

2. **Single-level observation**: Flows uses single-level observation for better performance

```dart
// Good - direct observation
final count = 0.obs;

// Avoid - nested observation
final data = RxMap({'count': 0.obs}); // Don't do this
```

3. **Dispose controllers**: Always dispose controllers when not needed

```dart
@override
void onClose() {
  // Cleanup
  super.onClose();
}
```

4. **Use named routes**: Named routes are faster than widget navigation

```dart
// Faster
Flow.toNamed('/detail', arguments: {'id': 123});

// Slower
Flow.to(DetailPage(id: 123));
```

## Example App

The `example/` directory contains a complete example app demonstrating all features:

- Dependency Injection with `Flow.put`/`Flow.find`
- Reactive state management with `Rx` types and `Flx` widgets
- Route management with `Flow.to`/`Flow.toNamed`
- Logic/State/View separation pattern
- Light/Dark theme switching
- Object passing between routes with editing capabilities

Run the example:

```bash
cd example
flutter pub get
flutter run
```

## Acknowledgments

Flows is inspired by the excellent work done on [GetX](https://pub.dev/packages/get) by Jonny Borges. We want to express our gratitude for the innovative approach GetX brought to Flutter development. Flows builds upon these ideas with a focus on performance optimization and API simplicity.

Special thanks to:
- [GetX](https://pub.dev/packages/get) - For pioneering reactive state management and DI in Flutter
- The Flutter team - For building an amazing UI framework

## License

```
MIT License

Copyright (c) 2026 Flows

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
