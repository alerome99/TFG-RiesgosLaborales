import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tfg/modelo/subRiesgo.dart';

class RiesgoInspeccionNotifier with ChangeNotifier{
  List<SubRiesgo> _riesgoList = [];
  SubRiesgo _currentRiesgo;

  UnmodifiableListView<SubRiesgo> get riesgoList => UnmodifiableListView(_riesgoList);

  SubRiesgo get currentRiesgo => _currentRiesgo;

  set riesgoList(List<SubRiesgo> riesgoList){
    _riesgoList = riesgoList;
    notifyListeners();
  }

  set currentRiesgo(SubRiesgo riesgo){
    _currentRiesgo = riesgo;
    notifyListeners();
  }
}