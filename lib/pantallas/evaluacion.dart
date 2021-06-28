import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:path/path.dart' as Path;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tfg/modelo/evaluacion.dart';
import 'package:tfg/notifiers/evaluacionRiesgo_notifier.dart';
import 'package:tfg/notifiers/inspeccion_notifier.dart';
import 'package:tfg/notifiers/riesgosInspeccion_notifier.dart';
import 'package:tfg/pantallas/listaEvaluaciones.dart';
import 'package:tfg/providers/db.dart';
import 'package:tfg/providers/operaciones.dart';
import 'package:tfg/widgets/fondo.dart';

class EvaluacionRiesgo extends StatefulWidget {
  @override
  _EvaluacionState createState() => _EvaluacionState();
}

class _EvaluacionState extends State<EvaluacionRiesgo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static final _formKey = GlobalKey<FormState>();
  File foto;
  double _valorDeficiencia = 0.0;
  double _valorExposicion = 1.0;
  double _valorConsecuencias = 10.0;
  int _deficiencia = 0;
  int _exposicion = 1;
  int _consecuencias = 10;
  PickedFile _imageFile;
  List<String> fotos = [];
  String imagePath;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _accionCorrectoraController =
      TextEditingController();
  final TextEditingController _longitudController = TextEditingController();
  final TextEditingController _latitudController = TextEditingController();    
  final TextEditingController _altitudController = TextEditingController();
  String _tipoFactorController;
  int idNueva = -1;
  final TextEditingController c1 = new TextEditingController();
  @override
  void initState() {
    super.initState();
    EvaluacionRiesgoNotifier evaluacionRiesgoNotifier =
        Provider.of<EvaluacionRiesgoNotifier>(context, listen: false);
    if (evaluacionRiesgoNotifier.currentEvaluacion != null) {
      _tituloController.text =
          evaluacionRiesgoNotifier.currentEvaluacion.titulo;
      if (evaluacionRiesgoNotifier.currentEvaluacion.tipo ==
          TipoFactor.Existente) {
        _tipoFactorController = "Existente";
      } else {
        _tipoFactorController = "Potencial";
      }
      _accionCorrectoraController.text =
          evaluacionRiesgoNotifier.currentEvaluacion.accionCorrectora;
      _valorDeficiencia = evaluacionRiesgoNotifier
          .currentEvaluacion.nivelDeficiencia
          .toDouble();
      _altitudController.text = evaluacionRiesgoNotifier.currentEvaluacion.altitud.toString();
      _longitudController.text = evaluacionRiesgoNotifier.currentEvaluacion.longitud.toString();
      _latitudController.text = evaluacionRiesgoNotifier.currentEvaluacion.latitud.toString();
      _valorExposicion =
          evaluacionRiesgoNotifier.currentEvaluacion.nivelExposicion.toDouble();
      _valorConsecuencias = evaluacionRiesgoNotifier
          .currentEvaluacion.nivelConsecuencias
          .toDouble();
      idNueva = evaluacionRiesgoNotifier.currentEvaluacion.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    EvaluacionRiesgoNotifier evaluacionRiesgoNotifier =
        Provider.of<EvaluacionRiesgoNotifier>(context, listen: false);
    if(idNueva == -1){
      idNueva = calcularIdEvaluacion(evaluacionRiesgoNotifier);
    }
    return WillPopScope(
      onWillPop: _onWillPopScope,
      child: Scaffold(
        key: _scaffoldKey,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children: <Widget>[
                Fondo(),
                SingleChildScrollView(
                  padding:
                      EdgeInsets.symmetric(vertical: 70.0, horizontal: 15.0),
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
      ),
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
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _crearTextFieldRiesgo(),
            _crearSeleccion(),
            _crearSliderNDeficiencia(),
            _crearSliderNExposicion(),
            _crearSliderNConsecuencias(),
            _crearFieldCoordenadas(),
            _crearTextFieldAccionCorrectora(),
            Container(
              height: 20,
            ),
            _crearBotonFoto(),
            _listaFotos(),
            _crearBoton(),
          ],
        ),
      ),
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
                _crearTextFieldLongitud(),
                _crearTextFieldAltitud()
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
      _longitudController.text = _locationData.latitude.toString();
      _latitudController.text = _locationData.longitude.toString();
      _altitudController.text = _locationData.altitude.toString();
    });

    _formKey.currentState.save();

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
      validator: (value) {
        if (value.length < 1) {
          return 'Pulse el botón del gps para rellenar el campo';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearTextFieldAltitud() {
    return TextFormField(
      keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
      controller: _altitudController,
      enabled: false,
      decoration: InputDecoration(
        labelText: 'Altitud',
        labelStyle: TextStyle(fontSize: 20.0),
      ),
      readOnly: true,
      validator: (value) {
        if (value.length < 1) {
          return 'Pulse el botón del gps para rellenar el campo';
        } else {
          return null;
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
      validator: (value) {
        if (value.length < 1) {
          return 'Pulse el botón del gps para rellenar el campo';
        } else {
          return null;
        }
      },
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
            ),
          ),
          Container(
            height: 7,
            width: _size.width * 0.8,
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
                value: _valorDeficiencia,
                min: 0,
                max: 10,
                divisions: 3,
                onChanged: (value) {
                  _valorDeficiencia = value;
                  switch (value.ceil()) {
                    case 1:
                      _deficiencia = 0;
                      break;
                    case 2:
                      _deficiencia = 2;
                      break;
                    case 3:
                      _deficiencia = 6;
                      break;
                    case 4:
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
            ),
          ),
          Container(
            height: 7,
            width: _size.width * 0.8,
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
                value: _valorExposicion,
                min: 1,
                max: 4,
                divisions: 3,
                onChanged: (value) {
                  _valorExposicion = value;
                  switch (value.ceil()) {
                    case 1:
                      _exposicion = 1;
                      break;
                    case 2:
                      _exposicion = 2;
                      break;
                    case 3:
                      _exposicion = 3;
                      break;
                    case 4:
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

  Widget _listaFotos() {
    FotoEvaluacion f1, f2;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('fotoEvaluacion')
            .where('idEvaluacion', isEqualTo: idNueva)
            .where('eliminada', isEqualTo: false)
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
                List<TableRow> rows = [];
                if (index % 2 == 0) {
                  if (index + 1 != snapshot.data.docs.length) {
                    f1 = new FotoEvaluacion(snapshot.data.docs[index]['url'],
                        snapshot.data.docs[index]['idEvaluacion']);
                    f2 = new FotoEvaluacion(
                        snapshot.data.docs[index + 1]['url'],
                        snapshot.data.docs[index + 1]['idEvaluacion']);
                    rows.add(TableRow(children: [
                      _tarjeta(context, f1),
                      _tarjeta(context, f2),
                    ]));
                  } else {
                    f1 = new FotoEvaluacion(snapshot.data.docs[index]['url'],
                        snapshot.data.docs[index]['idEvaluacion']);
                    rows.add(TableRow(children: [
                      _tarjeta(context, f1),
                    ]));
                  }
                }
                return Table(children: rows);
              });
        });
  }

  Widget _tarjeta(BuildContext context, FotoEvaluacion foto) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
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
                    image: NetworkImage(foto.path)),
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
                        onPressed: () {
                          eliminarFotoRiesgo(foto);
                        }),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _imageModal() {
    return Container(
        height: 100.0,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          children: <Widget>[
            Text(
              "Escoge una foto",
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton.icon(
                    onPressed: () {
                      takePhoto(ImageSource.camera);
                    },
                    icon: Icon(Icons.camera),
                    label: Text("Camera")),
                FlatButton.icon(
                    onPressed: () {
                      takePhoto(ImageSource.gallery);
                    },
                    icon: Icon(Icons.image),
                    label: Text("Gallery"))
              ],
            )
          ],
        ));
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      _imageFile = pickedFile;
    });
    if (pickedFile != null) {
      String fileName = Path.basename(_imageFile.path);
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child(fileName);
      var imageFile = File(_imageFile.path);
      UploadTask uploadTask = ref.putFile(imageFile);
      var imageUrl = await (await uploadTask).ref.getDownloadURL();
      uploadTask.then((res) {});
      imagePath = imageUrl.toString();
      FotoEvaluacion f = new FotoEvaluacion(imageUrl.toString(), idNueva);
      try {
        await addFotoEvaluacion(f);
      } catch (e) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Error al añadir la foto"),
        ));
      }
    }
  }

  Widget _crearBotonFoto() {
    return MaterialButton(
      minWidth: 200.0,
      height: 40.0,
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: ((builder) => _imageModal()),
        );
      },
      color: Colors.deepPurple,
      child: Text('Añadir foto', style: TextStyle(color: Colors.white)),
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
            ),
          ),
          Container(
            height: 7,
            width: _size.width * 0.8,
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
                value: _valorConsecuencias,
                min: 10,
                max: 100,
                divisions: 3,
                onChanged: (value) {
                  _valorConsecuencias = value;
                  switch (value.ceil()) {
                    case 1:
                      _consecuencias = 10;
                      break;
                    case 2:
                      _consecuencias = 25;
                      break;
                    case 3:
                      _consecuencias = 60;
                      break;
                    case 4:
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

  Future<bool> _onWillPopScope() {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("¿Seguro que quieres abandonar la evaluación?"),
        content: Text('Esto descartará lo añadido hasta el momento'),
        actions: [
          new ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => ListaRiesgosPorEvaluar()));
            },
            style: ElevatedButton.styleFrom(
                primary: Colors.blue, onPrimary: Colors.black, elevation: 5),
            child: Text('SI'),
          ),
          new ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
                primary: Colors.blue, onPrimary: Colors.black, elevation: 5),
            child: Text('NO'),
          ),
        ],
      ),
    );
  }

  Widget _crearTextFieldRiesgo() {
    return TextFormField(
      controller: _tituloController,
      style: TextStyle(fontSize: 18.0),
      textCapitalization: TextCapitalization.sentences,
      validator: (value) {
        if (value.length < 1) {
          return 'Ingrese una descripción para esta evaluación';
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
          labelText: 'Descripción evaluación',
          labelStyle: TextStyle(fontSize: 22.0, color: Colors.pinkAccent)),
    );
  }

  Widget _crearTextFieldAccionCorrectora() {
    return TextFormField(
      controller: _accionCorrectoraController,
      style: TextStyle(fontSize: 18),
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
          labelText: 'Acción Correctora',
          labelStyle: TextStyle(fontSize: 22.0, color: Colors.pinkAccent)),
      validator: (value) {
        if (value.length < 1) {
          return 'Ingrese un titulo para esta evaluación';
        } else {
          return null;
        }
      },
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
        onPressed: () {
          guardar();
        },
      ),
    );
  }

  void guardar() async {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (!_formKey.currentState.validate()) return;

    _formKey.currentState.save();

    InspeccionNotifier inspeccionNotifier =
        Provider.of<InspeccionNotifier>(context, listen: false);
    RiesgoInspeccionNotifier riesgoInspeccionNotifier =
        Provider.of<RiesgoInspeccionNotifier>(context, listen: false);
    EvaluacionRiesgoNotifier evaluacionRiesgoNotifier =
        Provider.of<EvaluacionRiesgoNotifier>(context, listen: false);
    Evaluacion eval = new Evaluacion(
        idNueva,
        riesgoInspeccionNotifier.currentRiesgo.idUnica,
        inspeccionNotifier.currentInspeccion.id,
        _tituloController.text,
        _accionCorrectoraController.text,
        _tipoFactorController,
        _valorDeficiencia.round(),
        _valorExposicion.round(),
        _valorConsecuencias.round(),
        _longitudController.text,
        _latitudController.text,
        _altitudController.text);
    if (_tipoFactorController == null) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Debes seleccionar un tipo de factor"),
      ));
    } else {
      try {
        if (evaluacionRiesgoNotifier.currentEvaluacion != null) {
          eval.setIdDocumento(
              evaluacionRiesgoNotifier.currentEvaluacion.getIdDocumento());
          await modificarEvaluacion(eval);
          String idDoc = "";
          for (int i = 0; i < riesgoInspeccionNotifier.riesgoList.length; i++){
            if(riesgoInspeccionNotifier.riesgoList[i].idUnica == riesgoInspeccionNotifier.currentRiesgo.idUnica){
                idDoc = riesgoInspeccionNotifier.riesgoList[i].idDocumento;
            }
          }
          await modificarCalculoRiesgo(idDoc, eval);
        } else {
          await addRiesgo(
              riesgoInspeccionNotifier.currentRiesgo, inspeccionNotifier, eval);
          await addEvaluacion(eval);
        }
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => ListaRiesgosPorEvaluar()));
      } catch (e) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Error al añadir evaluación"),
        ));
      }
    }
  }

  void eliminarFotoRiesgo(FotoEvaluacion f) async {
    try {
      await eliminarFoto(f);
    } catch (e) {}
  }
}
