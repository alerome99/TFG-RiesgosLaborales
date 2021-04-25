import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfg/notifiers/inspeccion_notifier.dart';
import 'package:tfg/notifiers/user_notifier.dart';

import 'notifiers/auth_notifier.dart';
import 'notifiers/riesgo_notifier.dart';
import 'pantallas/login.dart';
import 'pantallas/principal.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => InspeccionNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => RiesgoNotifier(),
        ),
      ],
      child: MyApp(),
    ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prevención Riesgos Laborales',
      theme: ThemeData(primaryColor: Colors.purple),
      home: Consumer<AuthNotifier>(
        builder: (context, notifier, child) {
          return notifier.user !=null ? MainPage() : Login();
        },
      ),
    );
  }
}