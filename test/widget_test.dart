// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:appiumtesting/counter_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('counter increments, decrements and resets', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CounterApp()));
    final counter = find.byKey(const ValueKey('counter'));

    expect(tester.widget<Text>(counter).data, '0');
    await tester.tap(find.byKey(const ValueKey('increment')));
    await tester.pump();

    expect(tester.widget<Text>(counter).data, '1');
    await tester.tap(find.byKey(const ValueKey('decrement')));
    await tester.pump();

    expect(tester.widget<Text>(counter).data, '0');

    await tester.tap(find.byKey(const ValueKey('increment')));
    await tester.tap(find.byKey(const ValueKey('increment')));
    await tester.pump();

    expect(tester.widget<Text>(counter).data, '2');
    await tester.tap(find.byKey(const ValueKey('reset')));
    await tester.pump();
    expect(tester.widget<Text>(counter).data, '0');
  });
}
