import 'dart:io';

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

    test('Comprobar cartas', () async {
      final campoTextoTelefono = find.byValueKey('campoTextoTelefonoInformacionInspector');
      
      expect(await driver.getText(campoTextoTelefono), "333 333 333");
      await driver.waitUntilNoTransientCallbacks();
    });

    test('Dar de baja exitoso', () async {
      final campoTextoTelefono = find.byValueKey('campoTextoTelefonoInformacionInspector');
      final campoTextoRazon = find.byValueKey('campoTextoRazonDarDeBaja');
      final botonDarDeBaja = find.byValueKey('botonDarDeBaja');
      await driver.tap(campoTextoRazon);
      await driver.enterText("test");
      expect(await driver.getText(campoTextoRazon), "test");
      await driver.tap(botonDarDeBaja);
      await driver.waitUntilNoTransientCallbacks();
    });
  });
}
