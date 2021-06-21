import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfg/modelo/subRiesgo.dart';
import 'package:tfg/notifiers/inspeccion_notifier.dart';
import 'package:tfg/notifiers/riesgoInspeccionEliminada_notifier.dart';
import 'package:tfg/notifiers/riesgo_notifier.dart';
import 'package:tfg/notifiers/riesgosInspeccion_notifier.dart';
import 'package:tfg/notifiers/subRiesgo_notifier.dart';
import 'package:tfg/pantallas/evaluacion.dart';
import 'package:tfg/providers/db.dart';
import 'package:tfg/providers/operaciones.dart';
import 'package:tfg/widgets/fondo.dart';

class SeleccionSubRiesgo extends StatefulWidget {
  @override
  _SeleccionSubRiesgoState createState() => _SeleccionSubRiesgoState();
}

class _SeleccionSubRiesgoState extends State<SeleccionSubRiesgo> {
  @override
  Widget build(BuildContext context) {
    RiesgoInspeccionEliminadaNotifier riesgoInspeccionEliminadaNotifier =
        Provider.of<RiesgoInspeccionEliminadaNotifier>(context, listen: false);
    InspeccionNotifier inspeccionNotifier =
        Provider.of<InspeccionNotifier>(context, listen: false);
    getRiesgosInspeccionTodos(
        riesgoInspeccionEliminadaNotifier, inspeccionNotifier);
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
            Text('Selecciona el riesgo laboral encontrado:',
                style: TextStyle(color: Colors.black, fontSize: 17.0))
          ],
        ),
      ),
    );
  }

  Widget _botonesRedondeados() {
    SubRiesgoNotifier subRiesgoNotifier =
        Provider.of<SubRiesgoNotifier>(context, listen: false);
    RiesgoNotifier riesgoNotifier =
        Provider.of<RiesgoNotifier>(context, listen: false);
    List<SubRiesgo> subRiesgos = [];
    for (int i = 0; i < subRiesgoNotifier.subRiesgoList.length; i++) {
      if (subRiesgoNotifier.subRiesgoList[i].idRiesgoPadre ==
          riesgoNotifier.currentRiesgo.id) {
        subRiesgos.add(subRiesgoNotifier.subRiesgoList[i]);
      }
    }
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: subRiesgos.length,
      itemBuilder: (BuildContext context, int index) {
        List<TableRow> rows = [];
        if (index % 2 == 0) {
          if (index + 1 != subRiesgos.length) {
            rows.add(TableRow(children: [
              _crearBotonRedondeado(Colors.blue, subRiesgos[index]),
              _crearBotonRedondeado(Colors.blue, subRiesgos[index + 1]),
            ]));
          } else {
            rows.add(TableRow(children: [
              _crearBotonRedondeado(Colors.blue, subRiesgos[index]),
              Container()
            ]));
          }
        }
        return Table(children: rows);
      },
    );
  }

  Widget _crearBotonRedondeado(Color color, SubRiesgo sr) {
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
        agregarRiesgo(sr);
      },
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Container(
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
      ),
    );
  }

  agregarRiesgo(SubRiesgo sr) async {
    RiesgoInspeccionEliminadaNotifier riesgoInspeccionEliminadaNotifier =
        Provider.of<RiesgoInspeccionEliminadaNotifier>(context, listen: false);
    try {
      int idNueva = calcularIdRiesgo(riesgoInspeccionEliminadaNotifier);
      sr.setIdUnica(idNueva);
      RiesgoInspeccionNotifier riesgoInspeccionNotifier =
          Provider.of<RiesgoInspeccionNotifier>(context, listen: false);
      riesgoInspeccionNotifier.currentRiesgo = sr;
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => EvaluacionRiesgo()));
    } catch (e) {
    }
  }
}
