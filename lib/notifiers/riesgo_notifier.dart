import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tfg/modelo/riesgo.dart';

class RiesgoNotifier with ChangeNotifier{
  List<Riesgo> _riesgoList = [];
  Riesgo _currentRiesgo;
  int _bandera;

  UnmodifiableListView<Riesgo> get riesgoList => UnmodifiableListView(_riesgoList);

  Riesgo get currentRiesgo => _currentRiesgo;

  int get bandera => _bandera;

  set riesgoList(List<Riesgo> riesgoList){
    _riesgoList = riesgoList;
    notifyListeners();
  }

  set currentRiesgo(Riesgo riesgo){
    _currentRiesgo = riesgo;
    notifyListeners();
  }

  set bandera(int b){
    _bandera = b;
    notifyListeners();
  }
}