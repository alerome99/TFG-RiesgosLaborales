import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tfg/notifiers/inspeccion_notifier.dart';
import 'package:tfg/notifiers/riesgo_notifier.dart';
import 'package:tfg/notifiers/subRiesgo_notifier.dart';
import 'package:tfg/notifiers/user_notifier.dart';
import 'package:tfg/pantallas/addInspeccion.dart';
import 'package:tfg/providers/riesgoProvider.dart';
import 'package:tfg/widgets/fondo.dart';
import 'package:tfg/widgets/menu.dart';

import '../customClipper.dart';
import '../providers/db.dart';
import 'listaInspecciones.dart';

class MainPage extends StatefulWidget {
  final User user;

  const MainPage({Key key, this.user}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String imagePath;
  final ImagePicker _picker = ImagePicker();
  Widget foto() {
    return WillPopScope(
      onWillPop: _onWillPopScope,
      child: Container(
        width: 180,
        height: 180,
        decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
                fit: BoxFit.fill,
                image: new NetworkImage(
                    "https://www.cursosfemxa.es/images/stories/virtuemart/product/privada-prevencion-riesgos-laborales.jpg")))),
    );
  }

  Widget parteSuperior() {
    return Container(
      height: 380.0,
      child: Stack(
        children: <Widget>[
          Container(),
          ClipPath(
            clipper: MyCustomClipper(),
            child: Container(
              height: 380.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  //image: NetworkImage("https://derecho.usal.es/wp-content/uploads/2017/11/constructionworkers-1200x565.jpg"),
                  //https://preventiam.com/wp-content/uploads/2019/09/tecnicas-prevencion-riesgos-laborales.jpg
                  image: NetworkImage("https://i2.wp.com/www.asesorus.es/wp-content/uploads/2019/11/prevencion-riesgos-laborales.jpg?fit=710%2C320&ssl=1"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 190.0),
                foto(),
              ],
            ),
          ),
        ],
      ),
      
    );
  }

  @override
  Widget build(BuildContext context) {
    UserNotifier userNotifier = Provider.of<UserNotifier>(context);
    InspeccionNotifier inspeccionNotifier =
        Provider.of<InspeccionNotifier>(context, listen: false);
    RiesgoNotifier riesgoNotifier =
        Provider.of<RiesgoNotifier>(context, listen: false);
    SubRiesgoNotifier subRiesgoNotifier =
        Provider.of<SubRiesgoNotifier>(context, listen: false);
    if (riesgoNotifier.bandera != 1) {
      inicializarRiesgos(riesgoNotifier);
    }
    if (subRiesgoNotifier.bandera != 1) {
      inicializarSubRiesgos(subRiesgoNotifier);
    }
    getInspecciones(inspeccionNotifier);
    getProvincias(inspeccionNotifier);
    getUser(userNotifier);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      drawer: Menu(),
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
          ),
          parteSuperior(),
          Align(
  alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 130, 24, 0),
            child: Text(
            "Welcome to ORI",
            style: TextStyle(
              fontSize: 38.0,
              color: Colors.blue,
            ),
            textAlign: TextAlign.center,
            ),
          ),
          ),
          Positioned(
            bottom: 50.0,
            child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 15.0, top: 15.0, bottom: 15.0),
                  height: 200,
                  width: 188,
                  child: Card(
                    color: Colors.grey,
                    child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ListaInspecciones()));
                        },
                        splashColor: Colors.blue,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(Icons.list_alt, size: 70.0),
                              Text('Inspecciones',
                                  style: new TextStyle(fontSize: 22.0)),
                            ],
                          ),
                        )),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 15.0, top: 15.0, bottom: 15.0),
                  height: 200,
                  width: 188,
                  child: Card(
                    color: Colors.grey,
                    child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  AddInspeccion()));
                        },
                        splashColor: Colors.blue,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(Icons.add_circle_rounded, size: 70.0),
                              Text('Add Inspection',
                                  style: new TextStyle(fontSize: 22.0)),
                            ],
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Future<bool> _onWillPopScope() {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("¿Seguro que quieres salir de la aplicación?"),
        actions: [
          new ElevatedButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            style: ElevatedButton.styleFrom(
                primary: Colors.blue, onPrimary: Colors.black, elevation: 5),
            child: Text('SI'),
          ),
          new ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
                primary: Colors.blue, onPrimary: Colors.black, elevation: 5),
            child: Text('NO'),
          ),
        ],
      ),
    );
  }
}
