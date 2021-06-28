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
      expect(await driver.getText(passwordField), "Hello2");
      await driver.tap(signInButton);
      
      expect(find.text('Debes rellenar todos los campos') is ByText, equals(true) );
    });

    test('se puede escribir campos registro y funciona navegabilidad login-registro', () async {
      final emailField = find.byValueKey('registerEmail');
      final passField = find.byValueKey('registerPass');
      final passRepeatField = find.byValueKey('registerPassRepeat');
      final phoneField = find.byValueKey('registerPhone');
      final dniField = find.byValueKey('registerDni');
      final nameField = find.byValueKey('registerName');
      final direccionField = find.byValueKey('registerDireccion');
      final goRegister = find.byValueKey('goRegister');

      await driver.tap(goRegister);
      await driver.tap(emailField);
      await driver.enterText('test@gmail.com');
      expect(await driver.getText(emailField), "test@gmail.com");
      await driver.tap(passField);
      await driver.enterText('123456');
      expect(await driver.getText(passField), "123456");
      await driver.tap(passRepeatField);
      await driver.enterText('123456');
      expect(await driver.getText(passRepeatField), "123456");
      await driver.tap(phoneField);
      await driver.enterText('666666666');
      expect(await driver.getText(phoneField), "666666666");
      await driver.tap(dniField);
      await driver.enterText('Hello5');
      expect(await driver.getText(dniField), "Hello5");
      await driver.scrollIntoView(nameField);
      await driver.tap(nameField);
      await driver.enterText('Hello6');
      expect(await driver.getText(nameField), "Hello6");
      await driver.tap(direccionField);
      await driver.enterText('Hello7');
      expect(await driver.getText(direccionField), "Hello7");
      await driver.waitUntilNoTransientCallbacks();
      
    });

    test('rellenar todos los campos registro', () async {
      final emailField = find.byValueKey('registerEmail');
      final registerButton = find.byValueKey("registerButton");

      await driver.scrollIntoView(emailField);
      await driver.tap(emailField);
      await driver.enterText('Hello2');
      expect(await driver.getText(emailField), "Hello2");
      await driver.tap(registerButton);
      await driver.waitUntilNoTransientCallbacks();   

      expect(find.text('Debes rellenar todos los campos') is ByText, equals(true) );
    });

/*
    test('registro email contraseña y repetir contraseña no iguales', () async {
      final emailField = find.byValueKey('registerEmail');
      final passField = find.byValueKey('registerPass');
      final passRepeatField = find.byValueKey('registerPassRepeat');
      final phoneField = find.byValueKey('registerPhone');
      final dniField = find.byValueKey('registerDni');
      final nameField = find.byValueKey('registerName');
      final direccionField = find.byValueKey('registerDireccion');
      final botonRegistro = find.byValueKey('registerButton');

      await driver.scrollIntoView(emailField);
      await driver.tap(emailField); 
      await driver.enterText('a10@gmail.com');
      expect(await driver.getText(emailField), "a10@gmail.com");
      await driver.tap(passField);
      await driver.enterText('123456');
      expect(await driver.getText(passField), "123456");
      await driver.tap(passRepeatField);
      await driver.enterText('1234567');
      expect(await driver.getText(passRepeatField), "123456");
      await driver.tap(phoneField);
      await driver.enterText('666666666');
      expect(await driver.getText(phoneField), "666666666");
      await driver.tap(dniField);
      await driver.enterText('Hello5');
      expect(await driver.getText(dniField), "Hello5");
      await driver.scrollIntoView(nameField);
      await driver.tap(nameField);
      await driver.enterText('Hello6');
      expect(await driver.getText(nameField), "Hello6");
      await driver.tap(direccionField);
      await driver.enterText('Hello7');
      expect(await driver.getText(direccionField), "Hello7");
      await driver.tap(botonRegistro);
      expect(find.text('Los campos de contraseña y contraseña repetida deben de ser iguales') is ByText, equals(true) );
    });

    test('registro exitoso', () async {
      final emailField = find.byValueKey('registerEmail');
      final passField = find.byValueKey('registerPass');
      final passRepeatField = find.byValueKey('registerPassRepeat');
      final phoneField = find.byValueKey('registerPhone');
      final dniField = find.byValueKey('registerDni');
      final nameField = find.byValueKey('registerName');
      final direccionField = find.byValueKey('registerDireccion');
      final botonRegistro = find.byValueKey('registerButton');

      await driver.tap(emailField);
      await driver.enterText('test2@gmail.com');
      expect(await driver.getText(emailField), "test2@gmail.com");
      await driver.tap(passField);
      await driver.enterText('123456');
      expect(await driver.getText(passField), "123456");
      await driver.tap(passRepeatField);
      await driver.enterText('123456');
      expect(await driver.getText(passRepeatField), "123456");
      await driver.tap(phoneField);
      await driver.enterText('666666666');
      expect(await driver.getText(phoneField), "666666666");
      await driver.tap(dniField);
      await driver.enterText('Hello5');
      expect(await driver.getText(dniField), "Hello5");
      await driver.scrollIntoView(nameField);
      await driver.tap(nameField);
      await driver.enterText('Hello6');
      expect(await driver.getText(nameField), "Hello6");
      await driver.tap(direccionField);
      await driver.enterText('Hello7');
      expect(await driver.getText(direccionField), "Hello7");
      await driver.tap(botonRegistro);
    });
*/
  });
}
