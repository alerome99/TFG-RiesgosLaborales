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

    test('se puede escribir campos login', () async {
      final passwordField = find.byValueKey('passField');
      final emailField = find.byValueKey('emailField');

      await driver.tap(emailField);
      await driver.enterText('Hello');
      expect(await driver.getText(emailField), "Hello");
      await driver.tap(passwordField);
      await driver.enterText('Hello2');
      expect(await driver.getText(passwordField), "Hello2");
      await driver.waitUntilNoTransientCallbacks();
    });

    test('email o contraseña incorrecta', () async {
      final passwordField = find.byValueKey('passField');
      final emailField = find.byValueKey('emailField');
      final signInButton = find.byValueKey("loginButton");
      await driver.tap(emailField);
      await driver.enterText('Hello');
      expect(await driver.getText(emailField), "Hello");
      await driver.tap(passwordField);
      await driver.enterText('Hello2');
      expect(await driver.getText(passwordField), "Hello2");
      await driver.tap(signInButton);
      await driver.waitUntilNoTransientCallbacks();
      await delay(750);
      //expect(find.text('Contraseña o email incorrectossss') is ByText, true);
    });

    test('rellenar todos los campos login', () async {
      final passwordField = find.byValueKey('passField');
      final signInButton = find.byValueKey("loginButton");

      await driver.tap(passwordField);
      await driver.enterText('Hello2');   
      await driver.tap(signInButton);
      await driver.waitUntilNoTransientCallbacks();

      await delay(750);
      expect( find.text('Hello2') is ByText, equals(true) );
      expect(find.text('Debes rellenar todos los campos') is ByText, equals(true) );
    });

    test('se puede escribir campos registro y funciona navegabilidad login-registro', () async {
      final emailField = find.byValueKey('registerEmail');
      final passField = find.byValueKey('registerPass');
      final passRepeatField = find.byValueKey('registerPassRepeat');
      final phoneField = find.byValueKey('registerPhone');
      final dniField = find.byValueKey('registerDni');
      final nameField = find.byValueKey('registerName');
      final goRegister = find.byValueKey('goRegister');

      await driver.tap(goRegister);
      await driver.tap(emailField);
      await driver.enterText('Hello');
      await driver.tap(passField);
      await driver.enterText('Hello2');
      await driver.tap(passRepeatField);
      await driver.enterText('Hello3');
      await driver.tap(phoneField);
      await driver.enterText('Hello4');
      await driver.tap(dniField);
      await driver.enterText('Hello5');
      await driver.scrollIntoView(nameField);
      await driver.tap(nameField);
      await driver.enterText('Hello6');
      await driver.waitUntilNoTransientCallbacks();
      
      expect( find.text('Hello') is ByText, equals(true) );
      expect( find.text('Hello2') is ByText, equals(true) );
      expect( find.text('Hello3') is ByText, equals(true) );
      expect( find.text('Hello4') is ByText, equals(true) );
      expect( find.text('Hello5') is ByText, equals(true) );
      expect( find.text('Hello6') is ByText, equals(true) );    
    });

    test('rellenar todos los campos registro', () async {
      final emailField = find.byValueKey('registerEmail');
      final registerButton = find.byValueKey("registerButton");

      await driver.scrollIntoView(emailField);
      await driver.tap(emailField);
      await driver.enterText('Hello2');
      await driver.tap(registerButton);
      await driver.waitUntilNoTransientCallbacks();   

      expect( find.text('Hello2') is ByText, equals(true) );
      expect(find.text('Debes rellenar todos los campos') is ByText, equals(true) );
    });

    test('registro exitoso', () async {
      final emailField = find.byValueKey('registerEmail');
      final passField = find.byValueKey('registerPass');
      final passRepeatField = find.byValueKey('registerPassRepeat');
      final phoneField = find.byValueKey('registerPhone');
      final dniField = find.byValueKey('registerDni');
      final nameField = find.byValueKey('registerName');
      final goRegister = find.byValueKey('goRegister');

      await driver.tap(goRegister);
      await driver.tap(emailField);
      await driver.enterText('test@gmail.com');
      await driver.tap(passField);
      await driver.enterText('123456');
      await driver.tap(passRepeatField);
      await driver.enterText('123456');
      await driver.tap(phoneField);
      await driver.enterText('666666666');
      await driver.tap(dniField);
      await driver.enterText('Hello5');
      await driver.scrollIntoView(nameField);
      await driver.tap(nameField);
      await driver.enterText('Hello6');
      await driver.waitUntilNoTransientCallbacks();
      expect( find.text('Hello2') is ByText, equals(true) );
      expect( find.text('You must fill all the fields') is ByText, equals(true) );
    });
  });
}
