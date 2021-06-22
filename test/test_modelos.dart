import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test/test.dart';
import 'package:tfg/modelo/evaluacion.dart';
import 'package:tfg/modelo/inspeccion.dart';
import 'package:tfg/modelo/subRiesgo.dart';
import 'package:tfg/modelo/user.dart';

void main() {
  group('Metodo from map', () {
    test('riesgo', () async {
      Map<String, dynamic> mapa = new Map();
      mapa['nombre'] = "a";
      mapa['icono'] = "a";
      mapa['eliminado'] = false;
      mapa['id'] = 1;
      mapa['idUnica'] = 1;
      mapa['evaluado'] = false;
      mapa['total'] = 0;
      SubRiesgo r = SubRiesgo.fromMap(mapa);
      expect(r.idUnica, 1);
      expect(r.eliminado, false);
    });

    test('evaluacion', () async {
      Map<String, dynamic> mapa = new Map();
      mapa['id'] = 1;
      mapa['tipoFactor'] = "Potencial";
      mapa['titulo'] = "a";
      mapa['idInspeccion'] = 2;
      mapa['idRiesgo'] = 2;
      mapa['accionCorrectora'] = "qa";
      mapa['nivelConsecuencias'] = 100;
      mapa['nivelDeficiencia'] = 1;
      mapa['nivelExposicion'] = 6;
      Evaluacion e = Evaluacion.fromMap(mapa);
      expect(e.id, 1);
      expect(e.nivelConsecuencias, 100);
    });

    test('fotoRiesgo', () async {
      Map<String, dynamic> mapa = new Map();
      mapa['eliminada'] = false;
      mapa['idEvaluacion'] = 15;
      mapa['url'] = "a";
      FotoEvaluacion f = FotoEvaluacion.fromMap(mapa);
      expect(f.idEvaluacionUnica, 15);
    });

    test('usuario', () async {
      Map<String, dynamic> mapa = new Map();
      mapa['email'] = "a";
      mapa['baja'] = false;
      mapa['motivo'] = "a";
      mapa['numero'] = "a";
      mapa['dni'] = "22222222S";
      mapa['url'] = "a";
      mapa['nombre'] = "a";
      mapa['tipo'] = "inspector";
      mapa['contraseña'] = "a";
      mapa['direccion'] = "a";
      Usuario u = Usuario.fromMap(mapa);
      expect(u.dni, "22222222S");
    });

    test('inspeccion', () async {
      Map<String, dynamic> mapa = new Map();
      mapa['id'] = 3;
      mapa['estado'] = "enRealizacion";
      mapa['fechaInicio'] = Timestamp.now();
      mapa['fechaFin'] = null;
      mapa['lugar'] = "a";
      mapa['provincia'] = "Valladolid";
      mapa['descripcion'] = "a";
      mapa['titulo'] = "a";
      mapa['nombreEmpresa'] = "a";
      Inspeccion i = Inspeccion.fromMap(mapa);
      expect(i.id, 3);
    });
  });
}
