import 'package:flutter/material.dart' hide Flow;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_flows/flows.dart';

void main() {
  test('Flow dependency injection works', () {
    // Test put and find
    Flow.put('test');
    expect(Flow.find<String>(), equals('test'));
    expect(Flow.isRegistered<String>(), isTrue);
  });

  test('Flow delete works', () {
    Flow.put('test2');
    Flow.delete<String>();
    expect(Flow.isRegistered<String>(), isFalse);
  });

  test('Rx types work', () {
    final count = 0.obs;
    expect(count.value, equals(0));
    count.value++;
    expect(count.value, equals(1));
  });

  test('RxList works', () {
    final list = RxList<String>(['a', 'b']);
    expect(list.length, equals(2));
    list.add('c');
    expect(list.length, equals(3));
  });

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
    final count = 0.obs;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FlxValue(count, (value) => Text('Count: $value')),
        ),
      ),
    );
    expect(find.text('Count: 0'), findsOneWidget);
  });
}
