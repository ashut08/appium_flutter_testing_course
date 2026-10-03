import 'package:appiumtesting/counter_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('counter controller', () {
    test('counter should be 0', () {
      final controller = CounterController();

      expect(controller.count, 0);
    });
    test('counter should be 1', () {
      final controller = CounterController();

      controller.increment();

      expect(controller.count, 1);
    });

    test('counter should be -1', () {
      final controller = CounterController();

      controller.decrement();

      expect(controller.count, -1);
    });
  });
}
