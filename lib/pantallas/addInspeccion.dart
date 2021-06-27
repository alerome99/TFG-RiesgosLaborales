import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tfg/modelo/inspeccion.dart';
import 'package:tfg/notifiers/inspeccion_notifier.dart';
import 'package:tfg/pantallas/listaEvaluaciones.dart';
import 'package:tfg/pantallas/mapa.dart';
import 'package:tfg/providers/db.dart';
import 'package:tfg/providers/operaciones.dart';
import 'package:tfg/widgets/fondo.dart';

class AddInspeccion extends StatefulWidget {
  @override
  _AddInspeccionState createState() => _AddInspeccionState();
}

class _AddInspeccionState extends State<AddInspeccion> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _nombreEmpresaController =
      TextEditingController();
  final TextEditingController controller = TextEditingController();
  String _provinciaController, recibido;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(children: <Widget>[
            Fondo(),
            Positioned(
              bottom: 0.0,
              right: 0.0,
              child: Container(
                padding: EdgeInsets.all(12.0),
                child: Row(
                  children: <Widget>[
                    FloatingActionButton.extended(
                      heroTag: UniqueKey(),
                      onPressed: () {
                        _mostrarAlertaInspeccion(context);
                      },
                      label: Text('CREAR NUEVA INSPECCIÓN'),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  void _mostrarAlertaInspeccion(BuildContext context) {
    final size = MediaQuery.of(context).size;
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 35.0),
              child: Container(
                width: size.width * 0.80,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 3.0,
                          offset: Offset(0.0, 5.0),
                          spreadRadius: 3.0)
                    ]),
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        gradient: LinearGradient(
                            colors: [Colors.lightGreen, Colors.greenAccent]),
                      ),
                      alignment: Alignment.center,
                      height: size.height * 0.1,
                      width: double.infinity,
                      child: Text(
                        'Nueva Inspección',
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 20.0,
                            color: Colors.white),
                      ),
                    ),
                    Material(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(14.0, 14.0, 28.0, 14.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              _crearTextFieldTitulo(),
                              _crearTextFieldLugar(),
                              _crearTextNombreEmpresa(),
                              _crearSelectorProvincia(),
                              _crearTextFieldDescripcion(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(
                          child: Text('Cancelar'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        FlatButton(
                          child: Text('Confirmar'),
                          onPressed: () {
                            agregarInspeccion();
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ));
        });
  }

  Widget _crearTextFieldDescripcion() {
    return TextFormField(
      controller: _descripcionController,
      maxLines: 4,
      validator: (value) {
        if (value.length < 1) {
          return 'Ingrese una descripción para la inspección';
        } else {
          return null;
        }
      },
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
          labelText: 'Descripcion', labelStyle: TextStyle(fontSize: 20.0)),
    );
  }

  Widget _crearSelectorProvincia() {
    InspeccionNotifier inspeccionNotifier =
        Provider.of<InspeccionNotifier>(context, listen: false);
    var _provincias = List<DropdownMenuItem>();
    List<String> listaProvincias = [];
    listaProvincias = ordenarProvincias(inspeccionNotifier);
    for (int i = 0; i < listaProvincias.length; i++) {
      _provincias.add(DropdownMenuItem(
        child: Text(listaProvincias[i]),
        value: listaProvincias[i],
      ));
    }

    return DropdownButtonFormField(
      decoration: InputDecoration(
          labelText: 'Provincia', labelStyle: TextStyle(fontSize: 20.0)),
      value: _provinciaController,
      items: _provincias,
      onChanged: (value) {
        setState(() {
          _provinciaController = value;
        });
      },
    );
  }

  Widget _crearTextFieldLugar() {
    InspeccionNotifier inspeccionNotifier =
        Provider.of<InspeccionNotifier>(context, listen: false);
    if (recibido != null) {
      _direccionController.text = recibido;
    }

    return Stack(
      children: [
        TextFormField(
          controller: _direccionController,
          maxLines: 2,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
              labelText: 'Dirección', labelStyle: TextStyle(fontSize: 20.0)),
          validator: (value) {
            if (value.length < 1) {
              return 'Ingrese el lugar en el que se va a realizar la inspección';
            } else {
              return null;
            }
          },
        ),
        Positioned(
          top: 32,
          right: -10,
          height: 40,
          width: 40,
          child: Container(
            child: Ink(
              decoration: ShapeDecoration(
                color: Colors.grey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: IconButton(
                  icon: Icon(Icons.map_outlined),
                  color: Colors.white,
                  onPressed: () async {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => Mapa())).then((value) { setState(() {_direccionController.text = inspeccionNotifier.currentInspeccion.lugar;});});                  
                  }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _crearTextFieldTitulo() {
    return TextFormField(
      controller: _tituloController,
      textCapitalization: TextCapitalization.words,
      validator: (value) {
        if (value.length < 1) {
          return 'Ingrese un titulo para la inspección';
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
          labelText: 'Nombre', labelStyle: TextStyle(fontSize: 20.0)),
    );
  }

  Widget _crearTextNombreEmpresa() {
    return TextFormField(
      controller: _nombreEmpresaController,
      validator: (value) {
        if (value.length < 1) {
          return 'Ingrese el nombre de la empresa';
        } else {
          return null;
        }
      },
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
          labelText: 'Empresa', labelStyle: TextStyle(fontSize: 20.0)),
    );
  }

  void agregarInspeccion() async {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (!_formKey.currentState.validate()) return;

    _formKey.currentState.save();

    InspeccionNotifier inspeccionNotifier =
        Provider.of<InspeccionNotifier>(context, listen: false);
    int idNueva = calcularIdInspeccion(inspeccionNotifier);
    print(idNueva);
    Inspeccion i = Inspeccion(
        idNueva,
        Timestamp.now(),
        null,
        _direccionController.text,
        "Valladolid",
        _descripcionController.text,
        _tituloController.text,
        _nombreEmpresaController.text);
    if (_provinciaController == null) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Debes escoger una provincia"),
      ));
    } else {
      try {
        await addInspeccion(i, inspeccionNotifier);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => ListaRiesgosPorEvaluar()));
      } catch (e) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Error al añadir inspección"),
        ));
      }
    }
  }
}
