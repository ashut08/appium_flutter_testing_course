import 'package:appiumtesting/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// How long to pause after each step so you can watch the app.
// Make it bigger to slow down, or Duration.zero to run at full speed.
const pause = Duration(seconds: 2);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('complete counter flow', (tester) async {
    await tester.pumpWidget(const PracticeApp());
    await tester.pumpAndSettle();
    await Future.delayed(pause);

    final increment = find.byKey(const ValueKey('increment'));
    final decrement = find.byKey(const ValueKey('decrement'));
    final reset = find.byKey(const ValueKey('reset'));

    expect(find.text('0'), findsOneWidget);

    await tester.tap(increment);
    await tester.pumpAndSettle();
    expect(find.text('1'), findsOneWidget);
    await Future.delayed(pause);

    await tester.tap(increment);
    await tester.pumpAndSettle();
    expect(find.text('2'), findsOneWidget);
    await Future.delayed(pause);

    await tester.tap(decrement);
    await tester.pumpAndSettle();
    expect(find.text('1'), findsOneWidget);
    await Future.delayed(pause);

    await tester.tap(reset);
    await tester.pumpAndSettle();
    expect(find.text('0'), findsOneWidget);
    await Future.delayed(pause);
  });
}
