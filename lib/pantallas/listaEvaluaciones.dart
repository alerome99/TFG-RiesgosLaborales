import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfg/modelo/riesgo.dart';
import 'package:tfg/modelo/subRiesgo.dart';
import 'package:tfg/notifiers/inspeccion_notifier.dart';
import 'package:tfg/notifiers/riesgo_notifier.dart';
import 'package:tfg/notifiers/riesgosInspeccion_notifier.dart';
import 'package:tfg/notifiers/subRiesgo_notifier.dart';
import 'package:tfg/pantallas/principal.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Fondo(),
          SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              children: <Widget>[
                _titulos(),
                _botonesRedondeados(),
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
                      //Metodo que cambie el estado de la inspeccion y redireccione a la pagina principal
                      /*
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => MainPage()));
                        */
                    },
                    label: Text('Finalizar inspección'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _titulos() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 10.0),
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

  Widget _botonesRedondeados(){
    RiesgoInspeccionNotifier riesgoInspeccionNotifier =
        Provider.of<RiesgoInspeccionNotifier>(context, listen: false);
    InspeccionNotifier inspeccionNotifier =
        Provider.of<InspeccionNotifier>(context, listen: false);
  print(riesgoInspeccionNotifier.riesgoList.length);
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: riesgoInspeccionNotifier.riesgoList.length,
      itemBuilder: (BuildContext context, int index) {
        List<TableRow> rows = [];
        if (index % 2 == 0) {
          if (!riesgoInspeccionNotifier.riesgoList[index].getEliminado()) {
            if (index + 1 != riesgoInspeccionNotifier.riesgoList.length) {
              rows.add(TableRow(children: [
                _crearBotonRedondeado(
                    Colors.blue, riesgoInspeccionNotifier.riesgoList[index]),
                _crearBotonRedondeado(Colors.blue,
                    riesgoInspeccionNotifier.riesgoList[index + 1]),
              ]));
            } else {
              rows.add(TableRow(children: [
                _crearBotonRedondeado(
                    Colors.blue, riesgoInspeccionNotifier.riesgoList[index]),
                Container()
              ]));
            }
          }
        }

        return Table(children: rows);
      },
    );
  }

  Widget _crearBotonRedondeado(Color color, SubRiesgo sr) {
    RiesgoInspeccionNotifier riesgoInspeccionNotifier =
        Provider.of<RiesgoInspeccionNotifier>(context, listen: false);
    final card = Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        FadeInImage(
          placeholder: AssetImage('assets/images/original.gif'),
          image: AssetImage('assets/icons/${sr.icono}_V-01.png'),
          fadeInDuration: Duration(milliseconds: 200),
          height: 160.0,
          fit: BoxFit.cover,
        ),
        Expanded(
          child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10.0),
              child: Text(sr.nombre,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14))),
        )
      ],
    ));

    return GestureDetector(
      onTap: () {
        riesgoInspeccionNotifier.currentRiesgo = sr;
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => EvaluacionRiesgo()));     
      },
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Stack(
          children: <Widget>[
            Container(
              height: 227.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.white,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                        offset: Offset(2.0, 10.0))
                  ]),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: card,
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              child: SizedBox(
                height: 40,
                width: 40,
                child: FlatButton(
                  padding: EdgeInsets.all(8.0),
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

  void eliminarRiesgoInspeccion(SubRiesgo sr) {
    RiesgoInspeccionNotifier riesgoInspeccionNotifier =
        Provider.of<RiesgoInspeccionNotifier>(context, listen: false);
    SubRiesgo sr2;
    for (int i = 0; i < riesgoInspeccionNotifier.riesgoList.length; i++) {
      if (riesgoInspeccionNotifier.riesgoList[i].id == sr.id) {
        sr2 = riesgoInspeccionNotifier.riesgoList[i];
        riesgoInspeccionNotifier.riesgoList[i].setEliminado();
      }
    }
    for (int i = 0; i < riesgoInspeccionNotifier.riesgoList.length; i++) {
      print(riesgoInspeccionNotifier.riesgoList[i].getEliminado());
        
    }
    actualizarRiesgo(true, sr2);

    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => ListaRiesgosPorEvaluar()));

  }
}
