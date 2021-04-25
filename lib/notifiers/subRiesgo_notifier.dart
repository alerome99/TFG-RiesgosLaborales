import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tfg/modelo/subRiesgo.dart';

class SubRiesgoNotifier with ChangeNotifier{
  List<SubRiesgo> _subRiesgoList = [];
  SubRiesgo _currentSubRiesgo;
  int _bandera;

  UnmodifiableListView<SubRiesgo> get subRiesgoList => UnmodifiableListView(_subRiesgoList);

  SubRiesgo get currentSubRiesgo => _currentSubRiesgo;

  int get bandera => _bandera;

  set subRiesgoList(List<SubRiesgo> riesgoList){
    _subRiesgoList = riesgoList;
    notifyListeners();
  }

  set currentSubRiesgo(SubRiesgo subRiesgo){
    _currentSubRiesgo = subRiesgo;
    notifyListeners();
  }

  set bandera(int b){
    _bandera = b;
    notifyListeners();
  }
}