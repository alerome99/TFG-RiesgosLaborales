import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tfg/modelo/evaluacion.dart';

class EvaluacionRiesgoNotifier with ChangeNotifier{
  List<Evaluacion> _evaluacionList = [];
  Evaluacion _currentEvaluacion;

  UnmodifiableListView<Evaluacion> get evaluacionList => UnmodifiableListView(_evaluacionList);

  Evaluacion get currentEvaluacion => _currentEvaluacion;

  set evaluacionList(List<Evaluacion> evaluacionList){
    _evaluacionList = evaluacionList;
    notifyListeners();
  }

  set currentEvaluacion(Evaluacion evaluacion){
    _currentEvaluacion = evaluacion;
    notifyListeners();
  }
}