import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:tfg/modelo/riesgo.dart';
import 'package:tfg/modelo/subRiesgo.dart';
import 'package:tfg/notifiers/riesgo_notifier.dart';


  List<Riesgo> _riesgos = [];
  List<SubRiesgo> _subRiesgos = [];

  inicializarRiesgos(RiesgoNotifier riesgoNotifier) async {
    final respuesta = await rootBundle.loadString('data/riesgos.json');
    Map dataMap = json.decode(respuesta);
    for (var i = 0; i < dataMap['riesgos'].length; i++) {
      Riesgo r = new Riesgo(dataMap['id'][i], dataMap['nombre'][i], dataMap['icono'][i]);
      _riesgos.add(r); 
    } 
    riesgoNotifier.riesgoList = _riesgos;
  }

  Future<List<SubRiesgo>> inicializarSubRiesgos() async {
    final respuesta = await rootBundle.loadString('data/subRiesgos.json');
    Map dataMap = json.decode(respuesta); 
    for (var i = 0; i < dataMap['subRiesgos'].length; i++) {
      SubRiesgo sr = new SubRiesgo(dataMap['id'][i], dataMap['nombre'][i], dataMap['icono'][i], dataMap['idPadre'][i]);
      _subRiesgos.add(sr);
    }
    return _subRiesgos;
  }
