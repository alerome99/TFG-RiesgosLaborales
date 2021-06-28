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

    test('Widget cambiar de contraseña cargado', () async {
      final passAntiguaField = find.byValueKey('passActual');
      final passNuevaField = find.byValueKey('passNueva');
      final passNuevaRepetidaField = find.byValueKey("passNuevaRepetida");
      await driver.tap(passAntiguaField);
      await driver.enterText('654321');
      await driver.tap(passNuevaField);
      await driver.enterText('123456');
      await driver.tap(passNuevaRepetidaField);
      await driver.enterText('123456');
      expect(await driver.getText(passAntiguaField), "654321");
      expect(await driver.getText(passNuevaField), "123456");
      expect(await driver.getText(passNuevaRepetidaField), "123456");
      await driver.waitUntilNoTransientCallbacks();
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
