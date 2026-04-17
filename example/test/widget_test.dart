// This is a basic Flutter widget test for Flows Framework.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart' hide Flow;
import 'package:flutter_test/flutter_test.dart';
import 'package:liteflows/flows.dart';

void main() {
  testWidgets('Flx widget builds', (WidgetTester tester) async {
    final count = 0.obs;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Flx(() => Text('Count: ${count.value}')),
        ),
      ),
    );

    expect(find.text('Count: 0'), findsOneWidget);
  });

  testWidgets('FlxValue widget builds', (WidgetTester tester) async {
    final name = 'Flows'.obs;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FlxValue(name, (value) => Text('Hello, $value!')),
        ),
      ),
    );

    expect(find.text('Hello, Flows!'), findsOneWidget);
  });

  testWidgets('Flow dependency injection works', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold()),
    );

    Flow.put('test_value');
    expect(Flow.find<String>(), equals('test_value'));
    expect(Flow.isRegistered<String>(), isTrue);

    Flow.delete<String>();
    expect(Flow.isRegistered<String>(), isFalse);
  });
}
