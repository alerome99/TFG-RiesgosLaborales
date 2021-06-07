import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:provider/provider.dart';
import 'package:tfg/main.dart' as app;
import 'package:tfg/notifiers/auth_notifier.dart';
import 'package:tfg/notifiers/evaluacionRiesgo_notifier.dart';
import 'package:tfg/notifiers/inspeccion_notifier.dart';
import 'package:tfg/notifiers/inspector_notifier.dart';
import 'package:tfg/notifiers/riesgoInspeccionEliminada_notifier.dart';
import 'package:tfg/notifiers/riesgo_notifier.dart';
import 'package:tfg/notifiers/riesgosInspeccion_notifier.dart';
import 'package:tfg/notifiers/subRiesgo_notifier.dart';
import 'package:tfg/notifiers/usuario_notifier.dart';
import 'package:tfg/pantallas/login.dart';
import 'package:tfg/pantallas/registro.dart';

void main() {
  // This line enables the extension.
  enableFlutterDriverExtension();

  // Call the `main()` function of the app, or call `runApp` with
  // any widget you are interested in testing.
  app.main();

}
