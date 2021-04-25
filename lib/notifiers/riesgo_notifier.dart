import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tfg/modelo/riesgo.dart';

class RiesgoNotifier with ChangeNotifier{
  List<Riesgo> _riesgoList = [];
  Riesgo _currentRiesgo;

  UnmodifiableListView<Riesgo> get riesgoList => UnmodifiableListView(_riesgoList);

  Riesgo get currentRiesgo => _currentRiesgo;

  set riesgoList(List<Riesgo> riesgoList){
    _riesgoList = riesgoList;
    notifyListeners();
  }

  set currentRiesgo(Riesgo riesgo){
    _currentRiesgo = riesgo;
    notifyListeners();
  }
}