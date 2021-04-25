import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:tfg/modelo/riesgo.dart';
import 'package:tfg/modelo/subRiesgo.dart';
import 'package:tfg/notifiers/riesgo_notifier.dart';
import 'package:tfg/notifiers/subRiesgo_notifier.dart';


  List<Riesgo> _riesgos = [];
  List<SubRiesgo> _subRiesgos = [];

  inicializarRiesgos(RiesgoNotifier riesgoNotifier) async {
    final respuesta = await rootBundle.loadString('data/riesgos.json');
    Map dataMap = json.decode(respuesta);
    for (var i = 0; i < dataMap['riesgos'].length; i++) {
      Riesgo r = new Riesgo(dataMap['riesgos'][i]['id'], dataMap['riesgos'][i]['nombre'], dataMap['riesgos'][i]['icono']);
      _riesgos.add(r); 
    } 
    riesgoNotifier.riesgoList = _riesgos;
    riesgoNotifier.bandera = 1;
  }

  inicializarSubRiesgos(SubRiesgoNotifier subRiesgoNotifier) async {
    final respuesta = await rootBundle.loadString('data/subRiesgos.json');
    Map dataMap = json.decode(respuesta); 
    for (var i = 0; i < dataMap['subRiesgos'].length; i++) {
      SubRiesgo sr = new SubRiesgo(dataMap['subRiesgos'][i]['id'], dataMap['subRiesgos'][i]['nombre'], dataMap['subRiesgos'][i]['icono'], dataMap['subRiesgos'][i]['idPadre']);
      _subRiesgos.add(sr);
    }
    subRiesgoNotifier.subRiesgoList = _subRiesgos;
    subRiesgoNotifier.bandera = 1;
  }
