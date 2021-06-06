import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfg/modelo/inspeccion.dart';
import 'package:tfg/notifiers/inspeccion_notifier.dart';
import 'package:tfg/pantallas/listaEvaluaciones.dart';
import 'package:tfg/widgets/fondo.dart';

class ListaInspecciones extends StatefulWidget {
  @override
  _ListaInspeccionesState createState() => _ListaInspeccionesState();
}

class _ListaInspeccionesState extends State<ListaInspecciones> {
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
            Text('Lista de inspecciones',
                style: TextStyle(color: Colors.black, fontSize: 17.0))
          ],
        ),
      ),
    );
  }

  Widget _botonesRedondeados() {
    InspeccionNotifier inspeccionNotifier =
        Provider.of<InspeccionNotifier>(context, listen: false);
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: inspeccionNotifier.inspeccionList.length,
      itemBuilder: (BuildContext context, int index) {
        List<TableRow> rows = [];
        if (inspeccionNotifier.inspeccionList[index].estado ==
            EstadoInspeccion.enRealizacion) {
          rows.add(TableRow(children: [
            _crearBotonRedondeado(
                Colors.blue, inspeccionNotifier.inspeccionList[index]),
          ]));
        }
        if (inspeccionNotifier.inspeccionList[index].estado ==
            EstadoInspeccion.pendiente) {
          rows.add(TableRow(children: [
            _crearBotonRedondeado(
                Colors.green, inspeccionNotifier.inspeccionList[index]),
          ]));
        }
        if (inspeccionNotifier.inspeccionList[index].estado ==
            EstadoInspeccion.cerrada) {
          rows.add(TableRow(children: [
            _crearBotonRedondeado(
                Colors.red, inspeccionNotifier.inspeccionList[index]),
          ]));
        }

        return Table(children: rows);
      },
    );
  }

  Widget _crearBotonRedondeado(Color color, Inspeccion i) {
    InspeccionNotifier inspeccionNotifier =
        Provider.of<InspeccionNotifier>(context, listen: false);
    final card = Container(
        color: color,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            FadeInImage(
              placeholder: AssetImage('assets/images/giphy-9.gif'),
              image: AssetImage('assets/icons/${100}_V-01.png'),
              fadeInDuration: Duration(milliseconds: 200),
              height: 160.0,
              fit: BoxFit.cover,
            ),
            Expanded(
              child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10.0),
                  child: Text(i.titulo,
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 14))),
            )
          ],
        ));

    return GestureDetector(
      onTap: () {
        if(i.getEstado()=="enRealizacion"){
          inspeccionNotifier.currentInspeccion = i;
          Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => ListaRiesgosPorEvaluar()));
        } 
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
