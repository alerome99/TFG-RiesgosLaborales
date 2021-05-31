import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfg/modelo/evaluacion.dart';
import 'package:tfg/modelo/riesgo.dart';
import 'package:tfg/modelo/subRiesgo.dart';
import 'package:tfg/notifiers/evaluacionRiesgo_notifier.dart';
import 'package:tfg/notifiers/inspeccion_notifier.dart';
import 'package:tfg/notifiers/riesgo_notifier.dart';
import 'package:tfg/notifiers/riesgosInspeccion_notifier.dart';
import 'package:tfg/notifiers/subRiesgo_notifier.dart';
import 'package:tfg/pantallas/principal.dart';
import 'package:tfg/pantallas/seleccionRiesgo.dart';
import 'package:tfg/pantallas/seleccionSubRiesgo.dart';
import 'package:tfg/providers/db.dart';
import 'package:tfg/widgets/fondo.dart';

import 'evaluacion.dart';

class ListaRiesgosPorEvaluar extends StatefulWidget {
  @override
  _ListaRiesgosPorEvaluarState createState() => _ListaRiesgosPorEvaluarState();
}

class _ListaRiesgosPorEvaluarState extends State<ListaRiesgosPorEvaluar> {
  @override
  void initState() {
    super.initState();
    _actualizarLista();
  }

  Future _actualizarLista() async {
    RiesgoInspeccionNotifier riesgoInspeccionNotifier =
        Provider.of<RiesgoInspeccionNotifier>(context, listen: false);
    EvaluacionRiesgoNotifier evaluacionRiesgoNotifier =
        Provider.of<EvaluacionRiesgoNotifier>(context, listen: false);
    InspeccionNotifier inspeccionNotifier =
        Provider.of<InspeccionNotifier>(context, listen: false);
    getRiesgosInspeccionNoEliminados(
        riesgoInspeccionNotifier, inspeccionNotifier);
    getEvaluaciones(evaluacionRiesgoNotifier);
  }

  @override
  Widget build(BuildContext context) {
        EvaluacionRiesgoNotifier evaluacionRiesgoNotifier =
        Provider.of<EvaluacionRiesgoNotifier>(context, listen: false);
    return WillPopScope(
      onWillPop: _onWillPopScope,
      child: Scaffold(
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
            Positioned(
              bottom: 0.0,
              right: 0.0,
              child: Container(
                padding: EdgeInsets.all(12.0),
                child: Row(
                  children: <Widget>[
                    FloatingActionButton.extended(
                      heroTag: UniqueKey(),
                      //icon: Icon(Icons.add_alert, size: 30.0),archive_outlined
                      //icon: Icon(Icons., size: 30.0),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: ((builder) => _confirmacionModal()),
                        );
                      },
                      label: Text('Finalizar inspección'),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              child: Container(
                padding: EdgeInsets.all(12.0),
                child: Row(
                  children: <Widget>[
                    FloatingActionButton.extended(
                      heroTag: UniqueKey(),
                      //icon: Icon(Icons.add_alert, size: 30.0),archive_outlined
                      //icon: Icon(Icons., size: 30.0),
                      icon: Icon(Icons.add_box_outlined, size: 30.0),
                      onPressed: () {
                        evaluacionRiesgoNotifier.currentEvaluacion = null;
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                SeleccionRiesgo()));
                      },
                      label: Text(''),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPopScope() {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("¿Seguro que quieres regrsar a la página anterior?"),
        content: Text('Esto le sacara de la inspección'),
        actions: [
          new ElevatedButton(
            onPressed: () {
              Navigator.pop(context, true);
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

  Widget _confirmacionModal() {
    return Container(
        height: 150.0,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        child: Column(
          children: <Widget>[
            Text(
              "¿Estás seguro de que quieres finalizar la inspección?",
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    finalizarInspeccion();
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.black,
                      elevation: 5),
                  child: Text('SI'),
                ),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.black,
                      elevation: 5),
                  child: Text('NO'),
                ),
              ],
            )
          ],
        ));
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
            Text('Selecciona el riesgo que quiere evaluar:',
                style: TextStyle(color: Colors.black, fontSize: 17.0))
          ],
        ),
      ),
    );
  }

  Widget _listaRiesgos() {
    InspeccionNotifier inspeccionNotifier =
        Provider.of<InspeccionNotifier>(context, listen: false);
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('riesgo')
            .where('idInspeccion',
                isEqualTo: inspeccionNotifier.currentInspeccion.id)
            .where('eliminado', isEqualTo: false)
            .where('evaluado', isEqualTo: false)
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
                Color col;
                if(snapshot.data.docs[index]['total'] <= 20){
                  col = Colors.green;
                }
                if(snapshot.data.docs[index]['id'] > 20 && snapshot.data.docs[index]['id']<=120){
                  col = Colors.yellow;
                }
                if(snapshot.data.docs[index]['id'] > 120 && snapshot.data.docs[index]['id']<=500){
                  col = Colors.orange;
                }
                if(snapshot.data.docs[index]['id'] > 500){
                  col = Colors.red;
                }
                SubRiesgo r = new SubRiesgo(
                    snapshot.data.docs[index]['id'],
                    snapshot.data.docs[index]['nombre'],
                    snapshot.data.docs[index]['icono'],
                    0,
                    snapshot.data.docs[index]['idUnica']);
                List<TableRow> rows = [];
                rows.add(TableRow(children: [
                  _crearBotonRedondeado(col, r),
                ]));
                return Table(children: rows);
              });
        });
  }

  Widget _crearBotonRedondeado(Color col, SubRiesgo sr) {
    RiesgoInspeccionNotifier riesgoInspeccionNotifier =
        Provider.of<RiesgoInspeccionNotifier>(context, listen: false);
    EvaluacionRiesgoNotifier evaluacionRiesgoNotifier =
        Provider.of<EvaluacionRiesgoNotifier>(context, listen: false);
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
                      child: Text(sr.nombre,
                          maxLines: 2,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16))),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      height: 40.0,
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
          Expanded(
            flex: 3,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/original.gif'),
              image: AssetImage('assets/icons/${sr.icono}_V-01.png'),
              fadeInDuration: Duration(milliseconds: 200),
              width: 110.0,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );

    return GestureDetector(
      onTap: () {
        for(int i = 0; i < evaluacionRiesgoNotifier.evaluacionList.length ; i++){
          if(evaluacionRiesgoNotifier.evaluacionList[i].idRiesgo == sr.idUnica){
            evaluacionRiesgoNotifier.currentEvaluacion = evaluacionRiesgoNotifier.evaluacionList[i];
          }
        }
        riesgoInspeccionNotifier.currentRiesgo = sr;
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
            Positioned(
              right: 0,
              top: 0,
              child: SizedBox(
                height: 30,
                width: 30,
                child: FlatButton(
                  padding: EdgeInsets.all(0.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  color: Color(0xFFF5F6F9),
                  onPressed: () {
                    eliminarRiesgoInspeccion(sr);
                  },
                  child: Icon(Icons.delete),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void eliminarRiesgoInspeccion(SubRiesgo sr) async {
    RiesgoInspeccionNotifier riesgoInspeccionNotifier =
        Provider.of<RiesgoInspeccionNotifier>(context, listen: false);
    SubRiesgo sr2;
    for (int i = 0; i < riesgoInspeccionNotifier.riesgoList.length; i++) {
      if (riesgoInspeccionNotifier.riesgoList[i].idUnica == sr.idUnica) {
        sr2 = riesgoInspeccionNotifier.riesgoList[i];
        riesgoInspeccionNotifier.riesgoList[i].setEliminado();
      }
    }
    try {
      await actualizarRiesgo(true, sr2);
      //Navigator.pop(context);
    } catch (e) {}
  }

  void finalizarInspeccion() async {
    InspeccionNotifier inspeccionNotifier =
        Provider.of<InspeccionNotifier>(context, listen: false);
    try {
      modificarEstadoComoPendienteInspeccion(
          inspeccionNotifier.currentInspeccion.getIdDocumento());
      Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => MainPage()));
    } catch (e) {}
  }
}
