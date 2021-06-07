// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('TFG App', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.
    // var emailField = find.byKey(Key("email-field"));

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    Future<void> delay([int milliseconds = 250]) async {
      await Future<void>.delayed(Duration(milliseconds: milliseconds));
    }

    test('check flutter driver health', () async {
      final health = await driver.checkHealth();
      expect(health.status, HealthStatus.ok);
    });

    test('inicio sesion administrador', () async {
      final passwordField = find.byValueKey('passField');
      final emailField = find.byValueKey('emailField');
      final signInButton = find.byValueKey("loginButton");

      await driver.tap(emailField);
      await driver.enterText('super@gmail.com');
      await driver.tap(passwordField);
      await driver.enterText('123456');
      await driver.tap(signInButton);
      await driver.waitUntilNoTransientCallbacks();
      
      expect( find.text('Inspectores') is ByText, equals(true) );
    });
  });
}
