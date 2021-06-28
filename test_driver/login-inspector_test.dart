import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('TFG App', () {

    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

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

    test('inicio sesion inspector', () async {
      final passwordField = find.byValueKey('passField');
      final emailField = find.byValueKey('emailField');
      final signInButton = find.byValueKey("loginButton");

      await driver.tap(emailField);
      await driver.enterText('a@gmail.com');
      expect(await driver.getText(emailField), "a@gmail.com");
      await driver.tap(passwordField);
      await driver.enterText('123456');
      expect(await driver.getText(passwordField), "123456");
      await driver.tap(signInButton);
      await driver.waitUntilNoTransientCallbacks();
      
      expect( find.text('Inspecciones') is ByText, equals(true) );
    });
  });
}
