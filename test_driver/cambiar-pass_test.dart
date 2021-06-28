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

    test('Widget cambiar de contraseña rellenar todos los campos', () async {
      final passNuevaField = find.byValueKey('passNueva');
      final passNuevaRepetidaField = find.byValueKey("passNuevaRepetida");
      final botonCambiarPass = find.byValueKey("botonCambiarPass");
      await driver.tap(passNuevaField);
      await driver.enterText('123456');
      await driver.tap(passNuevaRepetidaField);
      await driver.enterText('123456');
      expect(await driver.getText(passNuevaField), "123456");
      expect(await driver.getText(passNuevaRepetidaField), "123456");
      await driver.tap(botonCambiarPass);
      await driver.waitUntilNoTransientCallbacks();
      expect(await driver.getText(find.text("Necesario")), "Necesario");
    });

    test('Widget cambiar de contraseña introduciendo actual mal', () async {
      final passAntiguaField = find.byValueKey('passActual');
      final passNuevaField = find.byValueKey('passNueva');
      final passNuevaRepetidaField = find.byValueKey("passNuevaRepetida");
      final botonCambiarPass = find.byValueKey("botonCambiarPass");
      await driver.tap(passAntiguaField);
      await driver.enterText('654322');
      await driver.tap(passNuevaField);
      await driver.enterText('123456');
      await driver.tap(passNuevaRepetidaField);
      await driver.enterText('123456');
      expect(await driver.getText(passAntiguaField), "654322");
      expect(await driver.getText(passNuevaField), "123456");
      expect(await driver.getText(passNuevaRepetidaField), "123456");
      await driver.tap(botonCambiarPass);
      await driver.waitUntilNoTransientCallbacks();
      expect(await driver.getText(find.text("La contraseña introducida no es correcta")), "La contraseña introducida no es correcta");
    });

    test('Widget cambiar de contraseña introduciendo diferentes los campos', () async {
      final passAntiguaField = find.byValueKey('passActual');
      final passNuevaField = find.byValueKey('passNueva');
      final passNuevaRepetidaField = find.byValueKey("passNuevaRepetida");
      final botonCambiarPass = find.byValueKey("botonCambiarPass");
      await driver.tap(passAntiguaField);
      await driver.enterText('654321');
      await driver.tap(passNuevaField);
      await driver.enterText('123455');
      await driver.tap(passNuevaRepetidaField);
      await driver.enterText('123456');
      expect(await driver.getText(passAntiguaField), "654321");
      expect(await driver.getText(passNuevaField), "123455");
      expect(await driver.getText(passNuevaRepetidaField), "123456");
      await driver.tap(botonCambiarPass);
      await driver.waitUntilNoTransientCallbacks();
      expect(await driver.getText(find.text("Este campo debe coincidir con el anterior")), "Este campo debe coincidir con el anterior");
    });

    test('Widget cambiar de contraseña introduciendo el cambio igual a la actual', () async {
      final passAntiguaField = find.byValueKey('passActual');
      final passNuevaField = find.byValueKey('passNueva');
      final passNuevaRepetidaField = find.byValueKey("passNuevaRepetida");
      final botonCambiarPass = find.byValueKey("botonCambiarPass");
      await driver.tap(passAntiguaField);
      await driver.enterText('654321');
      await driver.tap(passNuevaField);
      await driver.enterText('654321');
      await driver.tap(passNuevaRepetidaField);
      await driver.enterText('654321');
      expect(await driver.getText(passAntiguaField), "654321");
      expect(await driver.getText(passNuevaField), "654321");
      expect(await driver.getText(passNuevaRepetidaField), "654321");
      await driver.tap(botonCambiarPass);
      await driver.waitUntilNoTransientCallbacks();
      expect(await driver.getText(find.text("La contraseña nueva debe ser diferente a la anterior")), "La contraseña nueva debe ser diferente a la anterior");
    });

    test('Widget cambiar de contraseña introduciendo menos de seis caracteres', () async {
      final passAntiguaField = find.byValueKey('passActual');
      final passNuevaField = find.byValueKey('passNueva');
      final passNuevaRepetidaField = find.byValueKey("passNuevaRepetida");
      final botonCambiarPass = find.byValueKey("botonCambiarPass");
      await driver.tap(passAntiguaField);
      await driver.enterText('654321');
      await driver.tap(passNuevaField);
      await driver.enterText('1');
      await driver.tap(passNuevaRepetidaField);
      await driver.enterText('1');
      expect(await driver.getText(passAntiguaField), "654321");
      expect(await driver.getText(passNuevaField), "1");
      expect(await driver.getText(passNuevaRepetidaField), "1");
      await driver.tap(botonCambiarPass);
      await driver.waitUntilNoTransientCallbacks();
      expect(await driver.getText(find.text("La contraseña debe de tener más de 6 caracteres")), "La contraseña debe de tener más de 6 caracteres");
    });

    test('cambio de contraseña', () async {
      final passAntiguaField = find.byValueKey('passActual');
      final passNuevaField = find.byValueKey('passNueva');
      final passNuevaRepetidaField = find.byValueKey("passNuevaRepetida");
      final botonCambiarPass = find.byValueKey("botonCambiarPass");
      await driver.tap(passAntiguaField);
      await driver.enterText('654321');
      await driver.tap(passNuevaField);
      await driver.enterText('123456');
      await driver.tap(passNuevaRepetidaField);
      await driver.enterText('123456');
      expect(await driver.getText(passAntiguaField), "654321");
      await driver.tap(botonCambiarPass);
      await driver.waitUntilNoTransientCallbacks();
    });
  });
}
