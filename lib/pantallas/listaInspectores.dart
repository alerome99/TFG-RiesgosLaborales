import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfg/modelo/evaluacion.dart';
import 'package:tfg/modelo/riesgo.dart';
import 'package:tfg/modelo/subRiesgo.dart';
import 'package:tfg/modelo/user.dart';
import 'package:tfg/notifiers/evaluacionRiesgo_notifier.dart';
import 'package:tfg/notifiers/inspeccion_notifier.dart';
import 'package:tfg/notifiers/riesgo_notifier.dart';
import 'package:tfg/notifiers/riesgosInspeccion_notifier.dart';
import 'package:tfg/notifiers/subRiesgo_notifier.dart';
import 'package:tfg/notifiers/usuario_notifier.dart';
import 'package:tfg/pantallas/principal.dart';
import 'package:tfg/pantallas/seleccionRiesgo.dart';
import 'package:tfg/pantallas/seleccionSubRiesgo.dart';
import 'package:tfg/providers/db.dart';
import 'package:tfg/widgets/fondo.dart';
import 'package:tfg/widgets/menu.dart';

import 'evaluacion.dart';

class ListaInspectores extends StatefulWidget {
  @override
  _ListaInspectoresState createState() => _ListaInspectoresState();
}

class _ListaInspectoresState extends State<ListaInspectores> {

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        drawer: Menu(),
        body: Stack(
          children: <Widget>[
            Fondo(),
            SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                children: <Widget>[
                  _titulos(),
                  //_botonesRedondeados(),
                  _listaRiesgos(),
                ],
              ),
            ),
          ],
        ),
    );
  }

  Widget _titulos() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(20.0, 35.0, 20.0, 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Prevención Riesgos Laborales',
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700)),
            SizedBox(height: 7.0),
            Text('Selecciona el inspector que quiere gestionar:',
                style: TextStyle(color: Colors.black, fontSize: 17.0))
          ],
        ),
      ),
    );
  }

  Widget _listaRiesgos() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('usuario')
            .snapshots(),
        builder: (
          context,
          snapshot,
        ) {
          if (snapshot.data == null)
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.red,
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.teal),
              ),
            );

          return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                Usuario u = new Usuario(snapshot.data.docs[index]['email'], null, snapshot.data.docs[index]['numero'], 
                  snapshot.data.docs[index]['dni'], snapshot.data.docs[index]['nombre'], snapshot.data.docs[index]['url'], snapshot.data.docs[index]['tipo']);
                List<TableRow> rows = [];
                rows.add(TableRow(children: [
                  _crearBotonRedondeado(u),
                ]));
                return Table(children: rows);
              });
        });
  }

  Widget _crearBotonRedondeado(Usuario u) {
    UsuarioNotifier usuarioNotifier =
        Provider.of<UsuarioNotifier>(context, listen: false);
    final card = Container(
      child: Row(
        children: [
          Expanded(
              flex: 7,
              child: Stack(
                children: [
                  Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.fromLTRB(10.0, 14.0, 10.0, 10.0),
                      child: Text(u.nombreCompleto,
                          maxLines: 2,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16))),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      height: 30.0,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10.0,
                                spreadRadius: 2.0,
                                offset: Offset(2.0, 10.0))
                          ]),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );

    return GestureDetector(
      onTap: () {
        usuarioNotifier.currentUser = u;
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => EvaluacionRiesgo()));
      },
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Stack(
          children: <Widget>[
            Container(
              height: 100.0,
              decoration:
                  BoxDecoration(color: Colors.white, boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                    offset: Offset(2.0, 10.0))
              ]),
              child: ClipRRect(
                child: card,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
