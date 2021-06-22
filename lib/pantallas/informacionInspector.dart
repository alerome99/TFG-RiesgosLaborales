import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tfg/notifiers/auth_notifier.dart';
import 'package:tfg/notifiers/inspector_notifier.dart';
import 'package:tfg/notifiers/usuario_notifier.dart';
import 'package:tfg/pantallas/mofidPerfil.dart';
import 'package:tfg/providers/db.dart';
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
  PickedFile _imageFile;
  final TextEditingController _razonController = TextEditingController();
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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.green,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
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
            SizedBox(height: 10.0),
            Text(
              inspectorNotifier.currentInspector.email,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 30.0),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                  child: Text(
                    'Dni:',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Recursive',
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: Text(
                    inspectorNotifier.currentInspector.dni,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Recursive',
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                  child: Text(
                    'Telefono:',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Recursive',
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: Text(
                    inspectorNotifier.currentInspector.telefono,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Recursive',
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                  child: Text(
                    'Dirección:',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Recursive',
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: Text(
                    inspectorNotifier.currentInspector.direccion,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Recursive',
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.0),
            Padding(
              padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
              child: TextFormField(
                controller: _razonController,
                maxLines: 4,
                validator: (value) {
                  if (value.length < 1) {
                    return 'Ingrese una descripción para la inspección';
                  } else {
                    return null;
                  }
                },
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                    labelText: 'Motivo baja',
                    labelStyle: TextStyle(fontSize: 20.0)),
              ),
            ),
            SizedBox(height: 20.0),
            RaisedButton(
              onPressed: () {
                darDeBaja();
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
      height: 270.0,
      child: Stack(
        children: <Widget>[
          Container(),
          ClipPath(
            clipper: MyCustomClipper(),
            child: Container(
              height: 270.0,
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
                inspectorNotifier.currentInspector.url == "a"
                    ? FotoNull()
                    : FotoNoNull(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget FotoNull() {
    InspectorNotifier inspectorNotifier =
        Provider.of<InspectorNotifier>(context, listen: false);
    return Container(
      width: 150,
      height: 150,
      child: Stack(
        fit: StackFit.expand,
        overflow: Overflow.visible,
        children: [
          CircleAvatar(
              backgroundImage: AssetImage('assets/images/usuario.png')),
        ],
      ),
    );
  }

  Widget FotoNoNull() {
    InspectorNotifier inspectorNotifier =
        Provider.of<InspectorNotifier>(context, listen: false);
    return Container(
      width: 150,
      height: 150,
      child: Stack(
        fit: StackFit.expand,
        overflow: Overflow.visible,
        children: [
          CircleAvatar(
              backgroundImage:
                  NetworkImage(inspectorNotifier.currentInspector.url)),
        ],
      ),
    );
  }

  void darDeBaja() async {
    InspectorNotifier inspectorNotifier =
        Provider.of<InspectorNotifier>(context, listen: false);
    UsuarioNotifier usuarioNotifier =
        Provider.of<UsuarioNotifier>(context, listen: false);
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    try {
      String idDoc = null;
      for (int i = 0; i < inspectorNotifier.inspectorList.length; i++){
        if(inspectorNotifier.inspectorList[i].email == inspectorNotifier.currentInspector.email){
          idDoc = inspectorNotifier.inspectorList[i].getIdDocumento();
        }
      }
        await darBajaInspector(idDoc, _razonController.text, inspectorNotifier, usuarioNotifier, authNotifier);
        Navigator.of(context).pop();
      } catch (e) {

      }
  } 
}
