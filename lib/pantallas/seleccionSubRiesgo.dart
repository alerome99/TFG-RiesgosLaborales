import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfg/modelo/riesgo.dart';
import 'package:tfg/modelo/subRiesgo.dart';
import 'package:tfg/notifiers/inspeccion_notifier.dart';
import 'package:tfg/notifiers/riesgo_notifier.dart';
import 'package:tfg/notifiers/riesgosInspeccion_notifier.dart';
import 'package:tfg/notifiers/subRiesgo_notifier.dart';
import 'package:tfg/pantallas/seleccionRiesgo.dart';
import 'package:tfg/providers/db.dart';
import 'package:tfg/widgets/fondo.dart';

class SeleccionSubRiesgo extends StatefulWidget {
  @override
  _SeleccionSubRiesgoState createState() => _SeleccionSubRiesgoState();
}

class _SeleccionSubRiesgoState extends State<SeleccionSubRiesgo> {
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
        // && index + 1 != subRiesgos.length
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
    RiesgoInspeccionNotifier riesgoInspeccionNotifier =
        Provider.of<RiesgoInspeccionNotifier>(context, listen: false);
    InspeccionNotifier inspeccionNotifier =
        Provider.of<InspeccionNotifier>(context, listen: false);
    bool existe = false;
    getRiesgosInspeccionTodos(riesgoInspeccionNotifier, inspeccionNotifier);
    SubRiesgo sr2;
    try{
      for (int i = 0; i < riesgoInspeccionNotifier.riesgoList.length; i++){
        if (riesgoInspeccionNotifier.riesgoList[i].id == sr.id ){
          existe = true;
          sr2 = riesgoInspeccionNotifier.riesgoList[i];
        }
      }
      if(!existe){
        await addRiesgo(sr, inspeccionNotifier);
      }else{
        await actualizarRiesgo(false, sr2);
      }
      
      Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => SeleccionRiesgo()));
    }
    catch (e) {
      //error en la operacion de BD
    }

  }
}