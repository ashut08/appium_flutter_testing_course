import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('fruit product list ', () {
    late FlutterDriver driver;
    final productList = find.byValueKey('product_list');
    final detailText = find.byValueKey('detail_text');

    SerializableFinder product(int index) => find.byValueKey('product_$index');
    SerializableFinder nameof(int index) => find.descendant(
      of: product(index),
      matching: find.byType("Text"),
      firstMatchOnly: true,
    );

    setUpAll(() async {
      driver = await FlutterDriver.connect();
      await driver.waitUntilFirstFrameRasterized();

      await driver.tap(find.byValueKey('open_list'));
    });

    tearDownAll(() async {
      await driver.close();
    });

    test('first product should be apple ', () async {
      await driver.tap(product(0));
      await driver.waitFor(detailText);
      expect(
        await driver.getText(detailText),
        "You have opened Apple with price 12.99",
      );
      await driver.tap(find.pageBack());
      await driver.waitForAbsent(detailText);
      await driver.waitFor(productList);
    });

    test("Scroll to last product open it and go back ", () async {
      await driver.scrollUntilVisible(productList, product(39), dyScroll: -500);

      expect(await driver.getText(nameof(39)), "Grapes");

      await driver.tap(product(39));
      await driver.waitFor(detailText);
      expect(
        await driver.getText(detailText),
        "You have opened Grapes with price 19.99",
      );
      await driver.tap(find.pageBack());
      await driver.waitFor(productList);
    });
  });
}
