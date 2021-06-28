import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:provider/provider.dart';
import 'package:tfg/notifiers/auth_notifier.dart';
import 'package:tfg/modelo/user.dart';
import 'package:tfg/notifiers/inspeccion_notifier.dart';
import 'package:tfg/notifiers/usuario_notifier.dart';
import 'package:tfg/pantallas/perfil.dart';

Future<void> main() async {
  enableFlutterDriverExtension();
  await Firebase.initializeApp();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => UsuarioNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => InspeccionNotifier(),
        ),
      ],
      child: MaterialApp(
        home: Builder(
          builder: (context) {
            UsuarioNotifier userNotifier =
                Provider.of<UsuarioNotifier>(context, listen: false);
            Usuario u = new Usuario(
                "a2@gmail.com",
                "654321",
                "333 333 333",
                "222222222A",
                "prueba prueba",
                "https://firebasestorage.googleapis.com/v0/b/tfg-riesgos-laborales-f85a8.appspot.com/o/3a25d5b9-9753-4705-b926-d6a2b691a6804804850712917333266.jpg?alt=media&token=d9dc2f8b-7241-4bc7-9cd4-c890817723d6",
                "inspector", 
                "wdqwdqwdqwd");
            userNotifier.currentUser = u;
            return Perfil();
          },
        ),
      ),
    ),
  );
}
