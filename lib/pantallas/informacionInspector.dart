import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfg/notifiers/inspector_notifier.dart';
import 'package:tfg/notifiers/usuario_notifier.dart';
import 'package:tfg/pantallas/mofidPerfil.dart';
import 'package:tfg/widgets/foto.dart';
import 'package:tfg/widgets/fotoCargada.dart';
import 'package:tfg/widgets/menu.dart';

import '../customClipper.dart';

class InformacionInspector extends StatefulWidget {
  @override
  _InformacionInspectorState createState() => _InformacionInspectorState();
}

class _InformacionInspectorState extends State<InformacionInspector> {
  String imagePath;
  bool showPassword = false;
  
  @override
  Widget build(BuildContext context) {
    InspectorNotifier inspectorNotifier =
        Provider.of<InspectorNotifier>(context, listen: false);
    Container(
        height: 220.0,
        width: 500.0,
        decoration: BoxDecoration(
          gradient:
              LinearGradient(colors: [Colors.cyanAccent, Colors.blueAccent]),
        ),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      drawer: Menu(),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            parteSuperior(),
            SizedBox(height: 10.0),
            Text(
              inspectorNotifier.currentInspector.nombreCompleto,
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              inspectorNotifier.currentInspector.tipo,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 50.0),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => ModifPerfil()));
              },
              color: Colors.green,
              padding: EdgeInsets.symmetric(horizontal: 50),
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                "DAR DE BAJA INSPECTOR",
                style: TextStyle(
                    fontSize: 16, letterSpacing: 2.2, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget parteSuperior() {
    InspectorNotifier inspectorNotifier =
        Provider.of<InspectorNotifier>(context, listen: false);
    return Container(
      height: 300.0,
      child: Stack(
        children: <Widget>[
          Container(),
          ClipPath(
            clipper: MyCustomClipper(),
            child: Container(
              height: 300.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage("https://picsum.photos/200"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, 1),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                inspectorNotifier.currentInspector.url == null
                    ? Foto()
                    : FotoCargada(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
