import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tfg/notifiers/inspeccion_notifier.dart';
import 'package:tfg/pantallas/seleccionRiesgo.dart';
import 'package:tfg/widgets/fondo.dart';

class AddInspeccion extends StatefulWidget {
  @override
  _AddInspeccionState createState() => _AddInspeccionState();
}

class _AddInspeccionState extends State<AddInspeccion> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _latitudController = TextEditingController();
  final TextEditingController _longitudController = TextEditingController();

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
                      label: Text('Create Inspection'),
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
              padding: EdgeInsets.symmetric(vertical: 150.0, horizontal: 35.0),
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
                            colors: [Colors.purple, Colors.blue]),
                      ),
                      alignment: Alignment.center,
                      height: size.height * 0.1,
                      width: double.infinity,
                      child: Text(
                        'New Inspection',
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 20.0,
                            color: Colors.white),
                      ),
                    ),
                    Material(
                      child: Container(
                        padding: EdgeInsets.all(20.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              _crearTextFieldTitulo(),
                              _crearTextFieldLugar(),
                              _crearSelectProvincia(),
                              //_crearFieldCoordenadas(),
                              _crearTextFieldDescripcion(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(child: Text('Cancelar'), onPressed: () => Navigator.of(context).pop(),),
                        FlatButton(
                          child: Text('Ok'),
                          onPressed: () {Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) => SeleccionRiesgo()));},
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
      maxLines: 4,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Descripcion',
        labelStyle: TextStyle(fontSize: 20.0)
      ),
    );
  }
  
  /*
  Widget _crearTextFieldLatitud() {
    return TextFormField(
      keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
      controller: _latitudController,
      decoration: InputDecoration(
        labelText: 'Latitud',
        labelStyle: TextStyle(fontSize: 20.0),
      ),
      readOnly: true,
      validator: (value) {
        bool flag; 
        if ( value.isEmpty) flag = false;
        (num.tryParse(value) == null ) ? flag = false : flag = true;

        if ( flag && num.tryParse(value).ceilToDouble() != 0.0){
          return null;
        } else {
          return 'Solo numeros';
        }   
      },
    );
  }

  Widget _crearFieldCoordenadas() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                _crearTextFieldLatitud(),
                _crearTextFieldLongitud()
              ],
            ),
          ),
          IconButton(
            iconSize: 30.0,
            icon: Icon(Icons.location_searching),
            color: Theme.of(context).primaryColor,
            onPressed: () => _getLocation()
          ),
        ],
      ),
    );
  }
 

  Widget _crearTextFieldLongitud() {
    return TextFormField(
      keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
      controller: _longitudController,
      decoration: InputDecoration(
        labelText: 'Longitud',
        labelStyle: TextStyle(fontSize: 20.0)
      ),
      validator: (value) {
        bool flag;
        if ( value.isEmpty) flag = false;
        (num.tryParse(value) == null ) ? flag = false : flag = true;

        if ( flag && num.tryParse(value).ceilToDouble() != 0.0){
          return null;
        } else {
          return 'Solo numeros';
        }  
      },
    );
  }

  _getLocation() async {
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    _formKey.currentState.save();
  }
  */

  Widget _crearSelectProvincia() {
    InspeccionNotifier inspeccionNotifier = Provider.of<InspeccionNotifier>(context, listen:false);
    var _selectedValue;
    var _provincias = List<DropdownMenuItem>();
    List<String> listaProvincias = [];
    inspeccionNotifier.provinciaList.forEach((provincia) {
      listaProvincias.add(provincia.provincia);
    });
    listaProvincias.sort();
    for (int i = 0; i<listaProvincias.length; i++){
      _provincias.add(DropdownMenuItem(child: Text(listaProvincias[i]), value: listaProvincias[i],));
    }

    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: 'Province',
        labelStyle: TextStyle(fontSize: 20.0)
      ),
      value: _selectedValue,
      items: _provincias,
      onChanged: ( value ) {
        setState(() {
          _selectedValue = value;
        });
      },
    );
  }

  Widget _crearTextFieldLugar() {
    return TextFormField(
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: 'Direction' ,
        labelStyle: TextStyle(fontSize: 20.0)
      ),
      validator: (value) {
        if ( value.length < 3 ) {
          return 'Ingrese la dirección donde se va a realizar la inspección';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearTextFieldTitulo() {
    return TextFormField(
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: 'Name' ,
        labelStyle: TextStyle(fontSize: 20.0)
      ),
    );
  }
}