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

    test('Error rellenar todos los campos evaluacion', () async {
      final botonGuardarEvaluacion = find.byValueKey('botonGuardarEvaluacion');
      await driver.scrollIntoView(botonGuardarEvaluacion);
      await driver.tap(botonGuardarEvaluacion);
      await driver.waitUntilNoTransientCallbacks();
      expect(await driver.getText(find.text("Ingrese una acción correctora para esta evaluación")), "Ingrese una acción correctora para esta evaluación");
    });

    test('Evaluacion realizada correctamente', () async {
      final campoDeTextoDescripcion = find.byValueKey('campoDescripcionEvaluacion');
      final campoDeTextoAccionCorrectora = find.byValueKey('campoAccionCorrectoraEvaluacion');
      final botonGuardarEvaluacion = find.byValueKey('botonGuardarEvaluacion');
      await driver.scrollIntoView(campoDeTextoDescripcion);
      await driver.tap(campoDeTextoDescripcion);
      await driver.enterText('test');
      expect(await driver.getText(campoDeTextoDescripcion), "test");
      await driver.tap(campoDeTextoAccionCorrectora);
      await driver.enterText('test');
      expect(await driver.getText(campoDeTextoAccionCorrectora), "test");
      await driver.scrollIntoView(botonGuardarEvaluacion);
      await driver.tap(botonGuardarEvaluacion);
    });
  });
}
