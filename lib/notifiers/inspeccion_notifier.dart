import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tfg/modelo/inspeccion.dart';

class InspeccionNotifier with ChangeNotifier{
  List<Inspeccion> _inspeccionList = [];
  List<Provincia> _provinciaList = [];
  Inspeccion _currentInspeccion;

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