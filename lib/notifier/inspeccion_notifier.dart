import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tfg/modelo/inspeccion.dart';
import 'package:rxdart/rxdart.dart';

class InspeccionNotifier with ChangeNotifier{
  List<Inspeccion> _inspeccionList = [];
  List<Provincia> _provinciaList = [];
  Inspeccion _currentInspeccion;

  /*
  final _provinciasController = new BehaviorSubject<List<String>>();
  List<String> get provincias => _provinciasController.value;

  obtenerProvincias() async {
    final respuesta = await rootBundle.loadString('lib/data/provincias.json');
    List<String> provincias = [];
    Map dataMap = json.decode(respuesta); 
    
    for (var i = 0; i < dataMap['provincias'].length; i++) {
      provincias.add(Provincia.fromJson(dataMap['provincias'][i]).nm);
    }
    
    _provinciasController.sink.add(provincias);
  }
  */

  UnmodifiableListView<Inspeccion> get inspeccionList => UnmodifiableListView(_inspeccionList);

  UnmodifiableListView<Provincia> get provinciaList => UnmodifiableListView(_provinciaList);



  Inspeccion get currentInspeccion => _currentInspeccion;

  set inspeccionList(List<Inspeccion> inspeccionList){
    _inspeccionList = inspeccionList;
    notifyListeners();
  }

  set provinciaList(List<Provincia> provinciaList){
    _provinciaList = provinciaList;
    notifyListeners();
  }

  set currentInspeccion(Inspeccion inspeccion){
    _currentInspeccion = inspeccion;
    notifyListeners();
  }
}