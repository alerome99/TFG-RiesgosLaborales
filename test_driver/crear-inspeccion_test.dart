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

    test('Error rellenar todos los campos agregar inspeccion', () async {
      final botonAgregarInspeccion = find.byValueKey('addInspeccion');
      final campoDeTextoTitulo = find.byValueKey('campoTituloAddInspeccion');

      final botonConfirmar = find.byValueKey('botonConfirmarAddInspeccion');
      await driver.tap(botonAgregarInspeccion);
      await driver.tap(campoDeTextoTitulo);
      await driver.enterText('test');
      await driver.tap(botonConfirmar);
      expect(await driver.getText(find.text("Ingrese el nombre de la empresa")), "Ingrese el nombre de la empresa");
    });

    test('Inspeccion agregada correctamente', () async {
      final campoDeTextoTitulo = find.byValueKey('campoTituloAddInspeccion');
      final campoDeTextoLugar = find.byValueKey('campoLugarAddInspeccion');
      final campoDeTextoNombreEmpresa = find.byValueKey('campoNombreEmpresaAddInspeccion');
      final campoDeTextoDescripcion = find.byValueKey('campoDescripcionAddInspeccion');
      final botonConfirmar = find.byValueKey('botonConfirmarAddInspeccion');
      await driver.tap(campoDeTextoTitulo);
      await driver.enterText('test');
      expect(await driver.getText(campoDeTextoTitulo), "test");
      await driver.tap(campoDeTextoLugar);
      await driver.enterText('test');
      expect(await driver.getText(campoDeTextoLugar), "test");
      await driver.tap(campoDeTextoNombreEmpresa);
      await driver.enterText('test');
      expect(await driver.getText(campoDeTextoNombreEmpresa), "test");
      await driver.tap(campoDeTextoDescripcion);
      await driver.enterText('test');
      expect(await driver.getText(campoDeTextoDescripcion), "test");
      await driver.tap(botonConfirmar);
      await driver.waitUntilNoTransientCallbacks();
    });
  });
}
