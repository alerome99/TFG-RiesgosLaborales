import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfg/notifiers/riesgo_notifier.dart';
import 'package:tfg/notifiers/subRiesgo_notifier.dart';
import 'package:tfg/widgets/fondo.dart';

class SeleccionRiesgo extends StatefulWidget {
  @override
  _SeleccionRiesgoState createState() => _SeleccionRiesgoState();
}

class _SeleccionRiesgoState extends State<SeleccionRiesgo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Fondo(),
          SingleChildScrollView(
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
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Prevención Riesgos Laborlaes',
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 10.0),
            Text('Selecciona el riesgo laboral encontrado',
                style: TextStyle(color: Colors.black, fontSize: 16.0))
          ],
        ),
      ),
    );
  }

  Widget _botonesRedondeados() {
    RiesgoNotifier riesgoNotifier =
        Provider.of<RiesgoNotifier>(context, listen: false);
    SubRiesgoNotifier subRiesgoNotifier =
        Provider.of<SubRiesgoNotifier>(context, listen: false);
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            riesgoNotifier.riesgoList.length.toString(),
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Recursive',
              fontSize: 57.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 40.0),
          Text(
            subRiesgoNotifier.subRiesgoList.length.toString(),
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Recursive',
              fontSize: 57.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
