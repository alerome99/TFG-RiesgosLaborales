import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfg/modelo/user.dart';
import 'package:tfg/notifiers/inspector_notifier.dart';
import 'package:tfg/pantallas/informacionInspector.dart';
import 'package:tfg/widgets/fondo.dart';
import 'package:tfg/widgets/menu.dart';

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
                  _listaInspectores(),
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
        padding: EdgeInsets.fromLTRB(20.0, 35.0, 20.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Prevención Riesgos Laborales',
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 22.0,
                    fontWeight: FontWeight.w700)),
            SizedBox(height: 7.0),
            Text('Selecciona el inspector que quiere gestionar:',
                style: TextStyle(color: Colors.black, fontSize: 17.0))
          ],
        ),
      ),
    );
  }

  Widget _listaInspectores() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('usuario')
            .where('tipo', isEqualTo: "inspector")
            .where('baja', isEqualTo: false)
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
                  snapshot.data.docs[index]['dni'], snapshot.data.docs[index]['nombre'], snapshot.data.docs[index]['url'], snapshot.data.docs[index]['tipo'], snapshot.data.docs[index]['direccion']);
                List<TableRow> rows = [];
                rows.add(TableRow(children: [
                  _crearBotonRedondeado(u),
                ]));
                return Table(children: rows);
              });
        });
  }

  Widget _crearBotonRedondeado(Usuario u) {
    InspectorNotifier inspectorNotifier =
        Provider.of<InspectorNotifier>(context, listen: false);
    final card = Container(
      child: Row(
        children: [
          Expanded(
              flex: 7,
              child: Stack(
                children: [
                  Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.fromLTRB(10.0, 14.0, 10.0, 14.0),
                      child: Padding( padding: const EdgeInsets.fromLTRB(20.0, 3.0, 10.0, 0.0), child: Text(u.nombreCompleto,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 20))),
                  ),
                ],
              )),
        ],
      ),
    );

    return GestureDetector(
      onTap: () {
        inspectorNotifier.currentInspector = u;
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => InformacionInspector()));
      },
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Stack(
          children: <Widget>[
            Container(
              height: 60.0,
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
