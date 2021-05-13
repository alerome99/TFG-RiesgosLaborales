import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:tfg/modelo/evaluacion.dart';
import 'package:tfg/notifiers/evaluacionRiesgo_notifier.dart';
import 'package:tfg/notifiers/inspeccion_notifier.dart';
import 'package:tfg/notifiers/riesgosInspeccion_notifier.dart';
import 'package:tfg/pantallas/listaEvaluaciones.dart';
import 'package:tfg/providers/db.dart';
import 'package:tfg/widgets/fondo.dart';

class EvaluacionRiesgo extends StatefulWidget {
  @override
  _EvaluacionState createState() => _EvaluacionState();
}

class _EvaluacionState extends State<EvaluacionRiesgo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  File foto;
  double _valueDeficiencia = 0.0;
  double _valueExposicion = 0.0;
  double _valueConsecuencias = 0.0;
  int _deficiencia = 0;
  int _exposicion = 0;
  int _consecuencias = 0;

  final TextEditingController _latitudController = TextEditingController();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _accionCorrectoraController = TextEditingController();
  String _tipoFactorController;
  final TextEditingController _longitudController = TextEditingController();

  final TextEditingController c1 = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Fondo(),
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 70.0, horizontal: 15.0),
                child: Column(
                  children: <Widget>[
                    _formulario(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      /*
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: _tomarForo,
      ),*/
    );
  }

  Widget _formulario(BuildContext context) {
    RiesgoInspeccionNotifier riesgoInspeccionNotifier =
        Provider.of<RiesgoInspeccionNotifier>(context, listen: false);
    final size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Container(
          width: size.width * 0.90,
          margin: EdgeInsets.symmetric(vertical: 0.0),
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
                height: size.height * 0.13,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Evaluación de Riesgo',
                        style: TextStyle(fontSize: 24.0, color: Colors.black)),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      riesgoInspeccionNotifier.currentRiesgo.nombre,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Text(''),
              _crearForm(),
            ],
          ),
        ),
        SizedBox(height: 100.0),
      ],
    );
  }

  Widget _crearForm() {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 5),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _crearTextFieldRiesgo(),
            _crearSeleccion(),
            _crearSliderNDeficiencia(),
            _crearSliderNExposicion(),
            _crearSliderNConsecuencias(),
            //_crearFieldCoordenadas(),
            _crearTextFieldAccionCorrectora(),
            //_mostrarFoto(),
            _crearBoton(),
          ],
        ),
      ),
    );
  }

  Widget _crearSeleccion() {
    return DropdownButtonFormField(
      decoration: InputDecoration(
          labelText: 'Tipo Factor',
          labelStyle: TextStyle(fontSize: 22.0, color: Colors.pinkAccent)),
      value: _tipoFactorController,
      onChanged: (value) => _tipoFactorController = value,
      items: <String>['Potencial', 'Existente']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: TextStyle(fontSize: 18)),
        );
      }).toList(),
    );
  }

  Widget _crearSliderNDeficiencia() {
    final _size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Column(
        children: <Widget>[
          Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: Text(
            'Nivel de Deficiencia',
            style: TextStyle(fontSize: 17),
          ),),
          Container(
            height: 7,
            width: _size.width*0.8,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.1),
              gradient: LinearGradient(colors: [     
                Color.fromRGBO(0, 255, 4, 1),   
                Color.fromRGBO(143, 255, 0, 1),  
                Color.fromRGBO(170, 255, 0, 1), 
                Color.fromRGBO(255, 128, 0, 1), 
                Color.fromRGBO(255, 89, 0, 1), 
                Color.fromRGBO(255, 0, 0, 1), 
              ]),
              borderRadius: BorderRadius.circular(10),
            ),
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor:
                    Theme.of(context).primaryColor.withOpacity(0.1),
                inactiveTrackColor:
                    Theme.of(context).primaryColor.withOpacity(0.1),
                trackShape: RoundedRectSliderTrackShape(),
                trackHeight: 4.0,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 11.0),
                thumbColor: Colors.blueAccent,
                overlayColor: Theme.of(context).primaryColor.withAlpha(32),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
                tickMarkShape: RoundSliderTickMarkShape(),
                activeTickMarkColor: Colors.black,
                inactiveTickMarkColor: Colors.black,
                valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                valueIndicatorColor:
                    Theme.of(context).primaryColor.withOpacity(0.8),
                valueIndicatorTextStyle: TextStyle(
                  color: Colors.white,
                ),
                showValueIndicator: ShowValueIndicator.always,
              ),
              child: Slider(
                value: _valueDeficiencia,
                min: 0,
                max: 3,
                divisions: 3,
                onChanged: (value) {
                  _valueDeficiencia = value;
                  switch (value.ceil()) {
                    case 0:
                      _deficiencia = 0;
                      break;
                    case 1:
                      _deficiencia = 2;
                      break;
                    case 2:
                      _deficiencia = 6;
                      break;
                    case 3:
                      _deficiencia = 10;
                      break;
                  }
                  setState(() {});
                },
              ),
            ),
          ),
          Container(
            width: _size.width * 0.82,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text('0'),
                Text('2'),
                Text('6'),
                Text('10'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _crearSliderNExposicion() {
    final _size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Column(
        children: <Widget>[
                    Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: Text(
            'Nivel de Exposicion',
            style: TextStyle(fontSize: 17),
          ),),
          Container(
            height: 7,
            width: _size.width*0.8,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.1),
              gradient: LinearGradient(colors: [     
                Color.fromRGBO(0, 255, 4, 1),   
                Color.fromRGBO(143, 255, 0, 1),  
                Color.fromRGBO(170, 255, 0, 1), 
                Color.fromRGBO(255, 128, 0, 1), 
                Color.fromRGBO(255, 89, 0, 1), 
                Color.fromRGBO(255, 0, 0, 1), 
              ]),
              borderRadius: BorderRadius.circular(10),
            ),
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor:
                    Theme.of(context).primaryColor.withOpacity(0.1),
                inactiveTrackColor:
                    Theme.of(context).primaryColor.withOpacity(0.1),
                trackShape: RoundedRectSliderTrackShape(),
                trackHeight: 4.0,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 11.0),
                thumbColor: Colors.blueAccent,
                overlayColor: Theme.of(context).primaryColor.withAlpha(32),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
                tickMarkShape: RoundSliderTickMarkShape(),
                activeTickMarkColor: Colors.black,
                inactiveTickMarkColor: Colors.black,
                valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                valueIndicatorColor:
                    Theme.of(context).primaryColor.withOpacity(0.8),
                valueIndicatorTextStyle: TextStyle(
                  color: Colors.white,
                ),
                showValueIndicator: ShowValueIndicator.always,
              ),
              child: Slider(
                value: _valueExposicion,
                min: 0,
                max: 3,
                divisions: 3,
                onChanged: (value) {
                  _valueExposicion = value;
                  switch (value.ceil()) {
                    case 0:
                      _exposicion = 1;
                      break;
                    case 1:
                      _exposicion = 2;
                      break;
                    case 2:
                      _exposicion = 3;
                      break;
                    case 3:
                      _exposicion = 4;
                      break;
                  }
                  setState(() {});
                },
              ),
            ),
          ),
          Container(
            width: _size.width * 0.82,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text('1'),
                Text('2'),
                Text('3'),
                Text('4'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _crearSliderNConsecuencias() {
    final _size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Column(
        children: <Widget>[
                    Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: Text(
            'Nivel Consecuencias',
            style: TextStyle(fontSize: 17),
          ),),
          Container(
            height: 7,
            width: _size.width*0.8,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.1),
              gradient: LinearGradient(colors: [     
                Color.fromRGBO(0, 255, 4, 1),   
                Color.fromRGBO(143, 255, 0, 1),  
                Color.fromRGBO(170, 255, 0, 1), 
                Color.fromRGBO(255, 128, 0, 1), 
                Color.fromRGBO(255, 89, 0, 1), 
                Color.fromRGBO(255, 0, 0, 1), 
              ]),
              borderRadius: BorderRadius.circular(10),
            ),
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor:
                    Theme.of(context).primaryColor.withOpacity(0.1),
                inactiveTrackColor:
                    Theme.of(context).primaryColor.withOpacity(0.1),
                trackShape: RoundedRectSliderTrackShape(),
                trackHeight: 4.0,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 11.0),
                thumbColor: Colors.blueAccent,
                overlayColor: Theme.of(context).primaryColor.withAlpha(32),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
                tickMarkShape: RoundSliderTickMarkShape(),
                activeTickMarkColor: Colors.black,
                inactiveTickMarkColor: Colors.black,
                valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                valueIndicatorColor:
                    Theme.of(context).primaryColor.withOpacity(0.8),
                valueIndicatorTextStyle: TextStyle(
                  color: Colors.white,
                ),
                showValueIndicator: ShowValueIndicator.always,
              ),
              child: Slider(
                value: _valueConsecuencias,
                min: 0,
                max: 3,
                divisions: 3,
                onChanged: (value) {
                  _valueConsecuencias = value;
                  switch (value.ceil()) {
                    case 0:
                      _consecuencias = 10;
                      break;
                    case 1:
                      _consecuencias = 25;
                      break;
                    case 2:
                      _consecuencias = 60;
                      break;
                    case 3:
                      _consecuencias = 100;
                      break;
                  }
                  setState(() {});
                },
              ),
            ),
          ),
          Container(
            width: _size.width * 0.82,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text('10'),
                Text('25'),
                Text('60'),
                Text('100'),
              ],
            ),
          ),
        ],
      ),
    );
  }

/*
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
            onPressed: _getLocation
          ),
        ],
      ),
    );
  }

  Widget _crearTextFieldLatitud() {
    return TextFormField(
      keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
      controller: _latitudController,
      enabled: false,
      decoration: InputDecoration(
        labelText: 'Latitud',
        labelStyle: TextStyle(fontSize: 20.0),
      ),
      readOnly: true,
      onSaved: (value) => _latitudController.text = '${evaluacion.coordenadas.latitud}',
      validator: (value) {
        bool flag;
        if ( value.isEmpty) flag = false;
        (num.tryParse(value) == null ) ? flag = false : flag = true;

        if ( flag ){
          return null;
        } else {
          return 'Solo números';
        }  
      },
    );
  }

  Widget _crearTextFieldLongitud() {
    return TextFormField(
      keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
      controller: _longitudController,
      enabled: false,
      decoration: InputDecoration(
        labelText: 'Longitud',
        labelStyle: TextStyle(fontSize: 20.0)
      ),
      onSaved: (value) => _longitudController.text = '${evaluacion.coordenadas.longitud}',
      validator: (value) {
        bool flag;
        if ( value.isEmpty) flag = false;
        (num.tryParse(value) == null ) ? flag = false : flag = true;

        if ( flag ){
          return null;
        } else {
          return 'Solo numeros';
        }  
      },
    );
  }*/

  Widget _crearTextFieldRiesgo() {
    return TextFormField(
      controller: _tituloController,
      style: TextStyle(fontSize: 18.0),
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
          labelText: 'Titulo evaluación',
          labelStyle: TextStyle(fontSize: 22.0, color: Colors.pinkAccent)),
    );
  }

  Widget _crearTextFieldAccionCorrectora() {
    return Container(
      padding: EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: _accionCorrectoraController,
        maxLines: 3,
        style: TextStyle(fontSize: 18),
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
            labelText: 'Acción Correctora',
            labelStyle: TextStyle(fontSize: 22.0, color: Colors.pinkAccent)),
      ),
    );
  }

  Widget _crearBoton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: RaisedButton.icon(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        color: Colors.deepPurple,
        textColor: Colors.white,
        label: Text('Guardar'),
        icon: Icon(Icons.save),
        onPressed: () {guardar();},
              ),
            );
          }
        
  void guardar() async {
      InspeccionNotifier inspeccionNotifier =
          Provider.of<InspeccionNotifier>(context, listen: false);
      RiesgoInspeccionNotifier riesgoInspeccionNotifier =
          Provider.of<RiesgoInspeccionNotifier>(context, listen: false); 
      EvaluacionRiesgoNotifier evaluacionRiesgoNotifier =
          Provider.of<EvaluacionRiesgoNotifier>(context, listen: false);   
      Evaluacion eval = new Evaluacion(1, riesgoInspeccionNotifier.currentRiesgo.id, inspeccionNotifier.currentInspeccion.id, _tituloController.text, _accionCorrectoraController.text, _tipoFactorController, _deficiencia, _exposicion, _consecuencias);
      if(_tituloController.text=="" || _tipoFactorController=="" || _accionCorrectoraController=="" ){
        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("You must fill all the fields"),));
      }
      else{
        try{
          await addEvaluacion(eval);
          await marcarRiesgoComoEvaluado(true, riesgoInspeccionNotifier.currentRiesgo);
          Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => ListaRiesgosPorEvaluar()));
        }
        catch (e) {
          //error en la operacion de BD
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Error al añadir evaluación"),
          ));
        }
      }
    }

/*
  Widget _mostrarFoto( ) {

    if ( evaluacion.fotos != null && evaluacion.fotos.length > 0 ) {
      
      if ( foto != null ) {

        return addFoto();
      }
      
      return fotoCarrusel( evaluacion.fotos );
    
    } else {

      if ( foto != null ) {
      
        return addFoto();
      
      } else {

        return _carruselNoImg();
      }

    }

  }

  Widget addFoto() {

    List<int> imageBytes = foto.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);

    if ( evaluacion.fotos == null ) {
      List<Foto> lista = List();
      Foto aux = Foto(foto: Base64Decoder().convert(base64Image), idEvaluacion: evaluacion.id);
      lista.add(aux);
      evaluacion.fotos = lista;
    } else {
      evaluacion.fotos.add(Foto(foto: Base64Decoder().convert(base64Image), idEvaluacion: evaluacion.id));
    }
    
    foto = null;
    return fotoCarrusel( evaluacion.fotos );

  }

  _procesarImagen( ImageSource source) async {
    final picker = ImagePicker();
    
    final pickedFile = await picker.getImage( source: source );

    foto = File(pickedFile.path);

    setState(() {});

  }

  _seleccionarForo(  ) async {

    _procesarImagen( ImageSource.gallery);

  }
  
  Widget _carruselNoImg() {

    final _screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      child: Container(
        height: _screenSize.height * 0.2,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Image(
              image: AssetImage('assets/img/no-image.png'),
              fit: BoxFit.cover,
            ),
        ),
      ),
      onTap: _tomarForo,
    );
  }
  
  Widget fotoCarrusel( List<Foto> fotos ) {

    final _pageController = new PageController(
      initialPage: 0,
      viewportFraction: 0.3
    );

    final _screenSize = MediaQuery.of(context).size;


    return Container(
      height: _screenSize.height * 0.2,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        itemCount: fotos.length,
        itemBuilder: ( context, i ) => _tarjeta(context, fotos[i])
      ),
    );
  }

  Widget _tarjeta( BuildContext context, Foto foto ) {

    return Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: FadeInImage(
                    height: 150.0,
                    width: 150.0,
                    fit: BoxFit.cover,
                    placeholder: AssetImage('assets/img/original.gif'),
                    image: Image.memory(
                      foto.foto,
                    ).image,
                  ),
                ),
                Positioned(
                  top: -2,
                  right: -2,
                  height: 40,
                  width: 40,
                  child: Container(
                    child: Ink(
                      decoration: ShapeDecoration(
                        color: Colors.red,
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.delete_forever),
                        color: Colors.white,
                        onPressed: () async {
                          if ( foto.id != null ){
                            await DBProvider.db.deleteFoto(foto);
                            evaluacion.fotos.remove(foto);
                            setState(() {});
                          } else {
                            evaluacion.fotos.remove(foto);
                            setState(() {});
                          }
                        }
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
          ],
        ),
      );

  }


  _tomarForo( ) async {

    _procesarImagen( ImageSource.camera);
  }

*/
/*
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

    setState(() {
      evaluacion.coordenadas.latitud = _locationData.latitude;
      print(_locationData.latitude);
      print(evaluacion.coordenadas.latitud);
      evaluacion.coordenadas.longitud = _locationData.longitude;
      print(_locationData.longitude);
      print(evaluacion.coordenadas.longitud);
    });

    _formKey.currentState.save();
*/
}
