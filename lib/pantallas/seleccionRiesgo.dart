import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfg/modelo/riesgo.dart';
import 'package:tfg/notifiers/evaluacionRiesgo_notifier.dart';
import 'package:tfg/notifiers/inspeccion_notifier.dart';
import 'package:tfg/notifiers/riesgo_notifier.dart';
import 'package:tfg/pantallas/listaEvaluaciones.dart';
import 'package:tfg/pantallas/seleccionSubRiesgo.dart';
import 'package:tfg/providers/db.dart';
import 'package:tfg/widgets/fondo.dart';

class SeleccionRiesgo extends StatefulWidget {
  @override
  _SeleccionRiesgoState createState() => _SeleccionRiesgoState();
}

class _SeleccionRiesgoState extends State<SeleccionRiesgo> {
  @override
  Widget build(BuildContext context) {
    EvaluacionRiesgoNotifier evaluacionRiesgoNotifier =
        Provider.of<EvaluacionRiesgoNotifier>(context, listen: false);
    getEvaluaciones(evaluacionRiesgoNotifier);
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
    InspeccionNotifier inspeccionNotifier =
        Provider.of<InspeccionNotifier>(context, listen: false);
    return SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(inspeccionNotifier.currentInspeccion.titulo,
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
    RiesgoNotifier riesgoNotifier =
        Provider.of<RiesgoNotifier>(context, listen: false);
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: riesgoNotifier.riesgoList.length,
      itemBuilder: (BuildContext context, int index) {
        List<TableRow> rows = [];
        if (index % 2 == 0) {
          if (index + 1 != riesgoNotifier.riesgoList.length) {
            rows.add(TableRow(children: [
              _crearBotonRedondeado(
                  Colors.blue, riesgoNotifier.riesgoList[index]),
              _crearBotonRedondeado(
                  Colors.blue, riesgoNotifier.riesgoList[index + 1]),
            ]));
          } else {
            rows.add(TableRow(children: [
              _crearBotonRedondeado(
                  Colors.blue, riesgoNotifier.riesgoList[index]),
              Container()
            ]));
          }
        }
        return Table(children: rows);
      },
    );
  }

  Widget _crearBotonRedondeado(Color color, Riesgo r) {
    RiesgoNotifier riesgoNotifier =
        Provider.of<RiesgoNotifier>(context, listen: false);
    final card = Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        FadeInImage(
          placeholder: AssetImage('assets/images/original.gif'),
          image: AssetImage('assets/icons/${r.icono}_V-01.png'),
          fadeInDuration: Duration(milliseconds: 200),
          height: 160.0,
          fit: BoxFit.cover,
        ),
        Expanded(
          child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10.0),
              child: Text(r.nombre,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14))),
        )
      ],
    ));

    return GestureDetector(
      onTap: () {
        riesgoNotifier.currentRiesgo = r;
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => SeleccionSubRiesgo()));
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
}
