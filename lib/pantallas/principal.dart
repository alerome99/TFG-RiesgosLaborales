import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tfg/notifiers/inspeccion_notifier.dart';
import 'package:tfg/notifiers/riesgo_notifier.dart';
import 'package:tfg/notifiers/user_notifier.dart';
import 'package:tfg/pantallas/addInspeccion.dart';
import 'package:tfg/providers/riesgoProvider.dart';
import 'package:tfg/widgets/menu.dart';

import '../customClipper.dart';
import '../providers/db.dart';

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
    return Container(
        width: 170,
        height: 170,
        decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
                fit: BoxFit.fill,
                image: new NetworkImage(
                    "https://www.cursosfemxa.es/images/stories/virtuemart/product/privada-prevencion-riesgos-laborales.jpg"))));
  }

  Widget parteSuperior() {
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
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 130.0),
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
    InspeccionNotifier inspeccionNotifier = Provider.of<InspeccionNotifier>(context, listen:false);
    RiesgoNotifier riesgoNotifier = Provider.of<RiesgoNotifier>(context, listen: false);
    inicializarRiesgos(riesgoNotifier);
    getProvincias(inspeccionNotifier);
    getUser(userNotifier);
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
            SizedBox(height: 30.0),
            Text(
              "Welcome to ORI",
              //FirebaseAuth.instance.currentUser.email,
              style: TextStyle(
                fontSize: 34.0,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30.0),
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 15.0, top: 15.0, bottom: 15.0),
                  height: 200,
                  width: 188,
                  child: Card(
                    color: Colors.grey,
                    child: InkWell(
                        onTap: () {},
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
                        onTap: () {Navigator.of(context)
                          .push(MaterialPageRoute(builder: (BuildContext context) => AddInspeccion()));},
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
          ],
        ),
      ),
    );
  }
}
