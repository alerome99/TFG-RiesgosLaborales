import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfg/modelo/inspeccion.dart';
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

  Widget _recuadro(Color c){
    return Container(
              width: 65,
              height: 65,
              color: c,
            );
  }

  Widget _texto( Inspeccion i ) {
    return Container(
      width: 180,
          child: Text(
            i.lugar,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0),
          ),
    );
  }

  Widget _tarjeta( Color color, Inspeccion i ) {
    return Container(
      height: 70.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            spreadRadius: 0.5,
            offset: Offset(-8.0, 10.0)
          )
        ],
      ),
      child: Card(
        elevation: 20.0,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0) ),
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

  _acciones( Inspeccion i ) {
    return  Container(
        padding: EdgeInsets.symmetric(vertical: 9.0),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _crearAcciones(Icons.edit, 'Inspeccionar', Colors.green, _inspeccionar, i),
            SizedBox(width: 5.0,),
            _crearAcciones(Icons.insert_drive_file, 'Informe', Colors.blueAccent, _crearInforme, i),
            SizedBox(width: 5.0,),
          ],
        ),
    );
  }

  _crearInforme( Inspeccion i ) async {
    
    /*
    if (await permission.Permission.storage.request().isGranted) {

      Map<String, List<s>> riesgosAgrupados = agruparRiesgos(inspeccion);

      List<String> linea;
      List<List<String>> datos = [];
      int index = 0;
      String tipoFactor;

      riesgosAgrupados.forEach((riesgo, deficiencias) {
        for (var i = 0; i < deficiencias.length; i++) {
          
          if ( deficiencias[i].evaluacion.tipoFactor == "Potencial" ) {
            tipoFactor = 'P';
          } else {
            tipoFactor = 'E';
          }

          if ( i == (deficiencias.length % 2) || deficiencias.length == 1 ) {
            linea = ["0${index+1}", "0${index+1}", "($tipoFactor)${deficiencias[i].evaluacion.riesgo}", "", "", "$riesgo", "", "", "${maxND(deficiencias)}", "${maxNE(deficiencias)}", "${_calculoNP(deficiencias)}", "${maxNC(deficiencias)}", "${_calculoNR(deficiencias)}", "${_calculoNI(deficiencias)}"];
            index++;
          } else {
            linea = ["", "", "($tipoFactor)${deficiencias[i].evaluacion.riesgo}", "", "", "", "", "", "", "", "", "", "", ""];
          }

          datos.add(linea);
          
        }
      });

      List<List<dynamic>> csvData = [
        <String>["Inspeccion","Pais", "Provincia", "Direccion", "Latitud", "Longitud"],
        [inspeccion.id, inspeccion.pais, inspeccion.provincia, inspeccion.direccion, inspeccion.latitud, inspeccion.longitud],
        [],
        <String>["FACTORES"],
        <String>["Codigo", "Nombre"], 
        ...inspeccion.deficiencias.map((item) => 
                [item.factorRiesgo.idPadre.toString()+item.factorRiesgo.codigo,
                item.factorRiesgo.nombre]),
        [],
        <String>["", "", "", "", "", "", "", "", "", "", "EVALUACION"],
        <String>["", "", "FACTOR RIESGO", "", "", "", "RIESGO", "", "", "PROBABILIDAD"],
        <String>["N", "ID", "FACTOR(POTENCIAL (P)/ EXISTENTE(E))", "", "", "", "RIESGO", "", "ND", "NE", "NP", "NC", "NR", "NI"],
        ...datos
      ];

      String csv = ListToCsvConverter(fieldDelimiter: ';').convert(csvData);

      Directory downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;

      final String path = '${downloadsDirectory.path}/lugar_inspeccion${inspeccion.id}.csv';
      final File file = File(path);

      await file.writeAsString(csv, mode: FileMode.write, encoding: utf8);

      _showSnackBar('Se ha creado el archivo CSV en Download');
      
    }*/
  }

  _inspeccionar( Inspeccion i ){
    InspeccionNotifier inspeccionNotifier =
        Provider.of<InspeccionNotifier>(context, listen: false);
    inspeccionNotifier.currentInspeccion = i;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => ListaRiesgosPorEvaluar()));
  }

  Widget _crearAcciones(IconData icono, String texto, Color color, Function f, Inspeccion inspeccion) {

      return GestureDetector(
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40.0),
              gradient: LinearGradient(
                begin: FractionalOffset(-0.93, -0.25),
                end: FractionalOffset.bottomRight,
                colors: [
                  Colors.white,
                  color.withOpacity(1.0)
                ],
              )
            ),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 16.0,
              child: Icon( icono, color: Colors.white, size: 20.0 ),
            ),
          ),
          Text(texto, style: TextStyle( color: color, fontSize: 10.0)),
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
        if (inspecciones[index].estado ==
            EstadoInspeccion.enRealizacion) {
          rows.add(TableRow(children: [
            _tarjeta(
                Colors.blue, inspecciones[index]),
          ]));
        }
        if (inspecciones[index].estado ==
            EstadoInspeccion.pendiente) {
          rows.add(TableRow(children: [
            _tarjeta(
                Colors.grey, inspecciones[index]),
          ]));
        }
        if (inspecciones[index].estado ==
            EstadoInspeccion.cerrada) {
          rows.add(TableRow(children: [
            _tarjeta(
                Colors.red, inspecciones[index]),
          ]));
        }

        return Table(children: rows);
      },
    );
  }
}
