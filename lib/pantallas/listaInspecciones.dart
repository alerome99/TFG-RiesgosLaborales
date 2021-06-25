import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:provider/provider.dart';
import 'package:tfg/modelo/evaluacion.dart';
import 'package:tfg/modelo/inspeccion.dart';
import 'package:tfg/modelo/subRiesgo.dart';
import 'package:tfg/modelo/informacion.dart';
import 'package:tfg/notifiers/inspeccion_notifier.dart';
import 'package:tfg/pantallas/listaEvaluaciones.dart';
import 'package:permission_handler/permission_handler.dart' as permission;
import 'package:tfg/providers/operaciones.dart';
import 'package:tfg/widgets/fondo.dart';

class ListaInspecciones extends StatefulWidget {
  @override
  _ListaInspeccionesState createState() => _ListaInspeccionesState();
}

class MyObject implements Comparable<MyObject> {
  Timestamp fecha;

  Timestamp getFecha() {
    return fecha;
  }

  void setFecha(Timestamp fecha) {
    this.fecha = fecha;
  }

  @override
  int compareTo(MyObject o) {
    return getFecha().compareTo(o.getFecha());
  }
}

final scaffoldKey = new GlobalKey<ScaffoldState>();

class _ListaInspeccionesState extends State<ListaInspecciones> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
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
        padding: EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Prevención Riesgos Laborales',
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 22.0,
                    fontWeight: FontWeight.w700)),
            SizedBox(height: 7.0),
            Text('Lista de inspecciones',
                style: TextStyle(color: Colors.black, fontSize: 17.0))
          ],
        ),
      ),
    );
  }

  Widget _recuadro(Color c) {
    return Container(
      width: 65,
      height: 65,
      color: c,
    );
  }

  Widget _texto(Inspeccion i) {
    return Container(
      width: 180,
      child: Text(
        i.titulo,
        maxLines: 2,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0),
      ),
    );
  }

  Widget _tarjeta(Color color, Inspeccion i) {
    return Container(
      height: 70.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              spreadRadius: 0.5,
              offset: Offset(-8.0, 10.0))
        ],
      ),
      child: Card(
        elevation: 20.0,
        shadowColor: Colors.black,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _texto(i),
            _recuadro(color),
            _acciones(i),
          ],
        ),
      ),
    );
  }

  _acciones(Inspeccion i) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 9.0),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          i.estado == EstadoInspeccion.enRealizacion
              ? _crearAcciones(
                  Icons.edit, 'Inspeccionar', Colors.green, _inspeccionar, i)
              : SizedBox(
                  width: 5.0,
                ),
          _crearAcciones(Icons.insert_drive_file, 'Informe', Colors.blueAccent,
              _crearInforme, i),
          SizedBox(
            width: 5.0,
          ),
        ],
      ),
    );
  }

  _crearInforme(Inspeccion i) async {
    if (await permission.Permission.storage.request().isGranted) {
      InspeccionNotifier inspeccionNotifier =
          Provider.of<InspeccionNotifier>(context, listen: false);
      inspeccionNotifier.currentInspeccion = i;

      List<SubRiesgo> subRiesgos = [];
      List<Evaluacion> evaluaciones = [];
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('riesgo')
          .where('idInspeccion',
              isEqualTo: inspeccionNotifier.currentInspeccion.id)
          .where('eliminado', isEqualTo: false)
          .where('evaluado', isEqualTo: true)
          .get();
      snapshot.docs.forEach((document) {
        SubRiesgo r = SubRiesgo.fromMap(document.data());
        r.setIdDocumento(document.id);
        subRiesgos.add(r);
      });

      List<Informacion> informacion = [];
      Evaluacion e;
      FotoEvaluacion fe;
      String urls = "";
      for (var i = 0; i < subRiesgos.length; i++) {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('evaluacion')
            .where('idRiesgo', isEqualTo: subRiesgos[i].idUnica)
            .get();
        snapshot.docs.forEach((document) {
          e = Evaluacion.fromMap(document.data());
          e.setIdDocumento(document.id);
          evaluaciones.add(e);
        });
        
        int ind = 0;

        QuerySnapshot snapshot2 = await FirebaseFirestore.instance
            .collection('fotoEvaluacion')
            .where('idEvaluacion', isEqualTo: e.id)
            .where('eliminada', isEqualTo: false)
            .get();
        snapshot2.docs.forEach((document) {
          fe = FotoEvaluacion.fromMap(document.data());
          urls = urls + "foto " + ind.toString() + ":" + fe.url + " - ";
          ind++;
        });
        String tipoF = "";
        if(e.tipo == TipoFactor.Potencial){
          tipoF = "Potencial";
        }else{
          tipoF = "Existente";
        }
        Informacion inf = new Informacion(
              subRiesgos[i].idRiesgoPadre.toString(),
              subRiesgos[i].id.toString(),
              subRiesgos[i].nombre,
              tipoF,
              e.nivelDeficiencia.toString(),
              e.nivelExposicion.toString(),
              e.nivelConsecuencias.toString(),
              subRiesgos[i].total.toString(),
              e.latitud,
              e.longitud,
              e.altitud,
              e.accionCorrectora,
              urls);
        informacion.add(inf);
      }
      String lugar = "";
      String lugarTemp = i.lugar;
      for (int i = 0; i < lugarTemp.length; i++) {
        if (lugarTemp[i] != ',') {
          lugar = lugar + lugarTemp[i];
        }
      }
      List<List<dynamic>> csvData = [
        <String>["Inspección", "Provincia", "Dirección", "Empresa"],
        [i.id, i.provincia, lugar, i.nombreEmpresa],
        [],
        <String>[
          "FACTORES"
        ], //hacer lista que convine evaluacion y riesgo en plan list<total> total.codigo total.nombre total.nd total.tr ...
        <String>[
          "Código",
          "Nombre",
          "Tipo",
          "NivelDeficiencia",
          "NivelExposicion",
          "NivelConsecuencias",
          "NivelRiesgo",
          "Latitud",
          "Longitud",
          "Altitud",
          "AccionCorrectora"
        ],
        ...informacion.map((item) => [
              item.idRiesgoPadre + " - " + item.idRiesgo,
              item.nombreRiesgo, item.nivelDeficiencia, item.nivelExposicion, item.nivelConsecuencia, item.total, item.latitud, item.longitud, item.altitud, item.accionCorrectora
            ]),
      ];

      String csv = ListToCsvConverter(fieldDelimiter: ';').convert(csvData);

      Directory downloadsDirectory =
          await DownloadsPathProvider.downloadsDirectory;

      final String path =
          '${downloadsDirectory.path}/lugar_inspeccion${i.id}.csv';
      final File file = File(path);

      await file.writeAsString(csv, mode: FileMode.write, encoding: utf8);
      scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text('Se ha creado el archivo CSV en Download'),
      ));
    }
  }

  _inspeccionar(Inspeccion i) {
    InspeccionNotifier inspeccionNotifier =
        Provider.of<InspeccionNotifier>(context, listen: false);
    inspeccionNotifier.currentInspeccion = i;
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => ListaRiesgosPorEvaluar()));
  }

  Widget _crearAcciones(IconData icono, String texto, Color color, Function f,
      Inspeccion inspeccion) {
    return GestureDetector(
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.0),
                gradient: LinearGradient(
                  begin: FractionalOffset(-0.93, -0.25),
                  end: FractionalOffset.bottomRight,
                  colors: [Colors.white, color.withOpacity(1.0)],
                )),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 16.0,
              child: Icon(icono, color: Colors.white, size: 20.0),
            ),
          ),
          Text(texto, style: TextStyle(color: color, fontSize: 10.0)),
        ],
      ),
      onTap: () => f(inspeccion),
    );
  }

  Widget _botonesRedondeados() {
    InspeccionNotifier inspeccionNotifier =
        Provider.of<InspeccionNotifier>(context, listen: false);
    List<Inspeccion> inspecciones = ordenarInspecciones(inspeccionNotifier);
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: inspecciones.length,
      itemBuilder: (BuildContext context, int index) {
        List<TableRow> rows = [];
        if (inspecciones[index].estado == EstadoInspeccion.enRealizacion) {
          rows.add(TableRow(children: [
            _tarjeta(Colors.blue, inspecciones[index]),
          ]));
        }
        if (inspecciones[index].estado == EstadoInspeccion.cerrada) {
          rows.add(TableRow(children: [
            _tarjeta(Colors.grey, inspecciones[index]),
          ]));
        }

        return Table(children: rows);
      },
    );
  }
}
