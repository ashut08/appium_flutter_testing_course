import 'package:appiumtesting/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('complete counter flow', (tester) async {
    await tester.pumpWidget(const PracticeApp());

    final increment = find.byKey(const ValueKey('increment'));
    final decrement = find.byKey(const ValueKey('decrement'));
    final reset = find.byKey(const ValueKey('reset'));

    expect(find.text('0'), findsOneWidget);

    await tester.tap(increment);
    await tester.pump();
    expect(find.text('1'), findsOneWidget);

    await tester.tap(increment);
    await tester.pump();
    expect(find.text('2'), findsOneWidget);

    await tester.tap(decrement);
    await tester.pump();
    expect(find.text('1'), findsOneWidget);

    await tester.tap(reset);
    await tester.pump();
    expect(find.text('0'), findsOneWidget);
  });
}
