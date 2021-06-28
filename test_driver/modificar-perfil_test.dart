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

    test('Ir a modificar perfil', () async {
      final botonIrModificarPerfil = find.byValueKey('botonIrAModificarPerfil');
      final campoTextoDireccion = find.byValueKey('campoTextoDireccionModificarPerfil');
      final campoTextoEmail = find.byValueKey('campoTextoEmailModificarPerfil');
      final campoTextoTelefono = find.byValueKey('campoTextoTelefonoModificarPerfil');

      await driver.tap(botonIrModificarPerfil);
      expect(await driver.getText(campoTextoDireccion), "wdqwdqwdqwd");
      expect(await driver.getText(campoTextoEmail), "a2@gmail.com");
      expect(await driver.getText(campoTextoTelefono), "333 333 333");
      await driver.waitUntilNoTransientCallbacks();
    });

    test('Cambiar direccion', () async {
      final botonIrModificarPerfil = find.byValueKey('botonIrAModificarPerfil');
      final campoTextoDireccion = find.byValueKey('campoTextoDireccionModificarPerfil');
      final campoTextoEmail = find.byValueKey('campoTextoEmailModificarPerfil');
      final campoTextoTelefono = find.byValueKey('campoTextoTelefonoModificarPerfil');
      final botonConfirmar = find.byValueKey('confirmarModificarPerfil');

      await driver.tap(campoTextoDireccion);
      await driver.enterText("test");
      expect(await driver.getText(campoTextoDireccion), "test");
      expect(await driver.getText(campoTextoEmail), "a2@gmail.com");
      expect(await driver.getText(campoTextoTelefono), "333 333 333");
      await driver.tap(botonConfirmar);
      await driver.tap(botonIrModificarPerfil);
      expect(await driver.getText(campoTextoDireccion), "test");
      expect(await driver.getText(campoTextoEmail), "a2@gmail.com");
      expect(await driver.getText(campoTextoTelefono), "333 333 333");
      await driver.waitUntilNoTransientCallbacks();
    });

    test('Cambiar telefono', () async {
      final botonIrModificarPerfil = find.byValueKey('botonIrAModificarPerfil');
      final campoTextoDireccion = find.byValueKey('campoTextoDireccionModificarPerfil');
      final campoTextoEmail = find.byValueKey('campoTextoEmailModificarPerfil');
      final campoTextoTelefono = find.byValueKey('campoTextoTelefonoModificarPerfil');
      final botonConfirmar = find.byValueKey('confirmarModificarPerfil');

      await driver.tap(campoTextoTelefono);
      await driver.enterText("test");
      expect(await driver.getText(campoTextoDireccion), "test");
      expect(await driver.getText(campoTextoEmail), "a2@gmail.com");
      expect(await driver.getText(campoTextoTelefono), "test");
      await driver.tap(botonConfirmar);
      await driver.tap(botonIrModificarPerfil);
      expect(await driver.getText(campoTextoDireccion), "test");
      expect(await driver.getText(campoTextoEmail), "a2@gmail.com");
      expect(await driver.getText(campoTextoTelefono), "test");
      await driver.waitUntilNoTransientCallbacks();
    });

    test('Cambiar telefono', () async {
      final botonIrModificarPerfil = find.byValueKey('botonIrAModificarPerfil');
      final campoTextoDireccion = find.byValueKey('campoTextoDireccionModificarPerfil');
      final campoTextoEmail = find.byValueKey('campoTextoEmailModificarPerfil');
      final campoTextoTelefono = find.byValueKey('campoTextoTelefonoModificarPerfil');
      final botonConfirmar = find.byValueKey('confirmarModificarPerfil');

      await driver.tap(campoTextoTelefono);
      await driver.enterText("test");
      expect(await driver.getText(campoTextoDireccion), "test");
      expect(await driver.getText(campoTextoEmail), "a2@gmail.com");
      expect(await driver.getText(campoTextoTelefono), "test");
      await driver.tap(botonConfirmar);
      await driver.tap(botonIrModificarPerfil);
      expect(await driver.getText(campoTextoDireccion), "test");
      expect(await driver.getText(campoTextoEmail), "a2@gmail.com");
      expect(await driver.getText(campoTextoTelefono), "test");
      await driver.waitUntilNoTransientCallbacks();
    });
  });
}
