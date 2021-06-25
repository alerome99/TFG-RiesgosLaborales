import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test/test.dart';
import 'package:tfg/modelo/evaluacion.dart';
import 'package:tfg/modelo/inspeccion.dart';
import 'package:tfg/modelo/subRiesgo.dart';
import 'package:tfg/notifiers/evaluacionRiesgo_notifier.dart';
import 'package:tfg/notifiers/inspeccion_notifier.dart';
import 'package:tfg/notifiers/riesgoInspeccionEliminada_notifier.dart';
import 'package:tfg/providers/operaciones.dart';

void main() {
  group('Operaciones de utilidad', () {
    test('ordenar inspecciones por fecha', () async {
      List<Inspeccion> inspecciones = [];
      DateTime date = DateTime.parse("1969-07-20 20:18:04Z"); 
      Timestamp fechaInicio = new Timestamp.fromDate(date);
      inspecciones.add(new Inspeccion(1, fechaInicio, null, null, null, null, null, null));
      date = DateTime.parse("1964-07-20 20:18:04Z"); 
      fechaInicio = new Timestamp.fromDate(date);
      inspecciones.add(new Inspeccion(2, fechaInicio, null, null, null, null, null, null));
      date = DateTime.parse("1973-07-20 20:18:04Z"); 
      fechaInicio = new Timestamp.fromDate(date);
      inspecciones.add(new Inspeccion(3, fechaInicio, null, null, null, null, null, null));
      date = DateTime.parse("1979-07-20 20:18:04Z"); 
      fechaInicio = new Timestamp.fromDate(date);
      inspecciones.add(new Inspeccion(4, fechaInicio, null, null, null, null, null, null));
      InspeccionNotifier inspeccionNotifier = InspeccionNotifier();
      inspeccionNotifier.inspeccionList = inspecciones;
      expect(inspecciones[0].id, 1);
      expect(inspecciones[1].id, 2);
      expect(inspecciones[2].id, 3);
      expect(inspecciones[3].id, 4);
      inspecciones = ordenarInspecciones(inspeccionNotifier);
      expect(inspecciones[0].id, 4);
      expect(inspecciones[1].id, 3);
      expect(inspecciones[2].id, 1);
      expect(inspecciones[3].id, 2);
    });

    test('ordenar inspecciones por estado', () async {
      List<Inspeccion> inspecciones = [];
      DateTime date = DateTime.parse("1969-07-20 20:18:04Z"); 
      Timestamp fechaInicio = new Timestamp.fromDate(date);
      Inspeccion i = new Inspeccion(1, fechaInicio, null, null, null, null, null, null);
      i.setEstado(EstadoInspeccion.cerrada);
      inspecciones.add(i);
      i = new Inspeccion(2, fechaInicio, null, null, null, null, null, null);
      i.setEstado(EstadoInspeccion.enRealizacion);
      inspecciones.add(i);
      i = new Inspeccion(3, fechaInicio, null, null, null, null, null, null);
      i.setEstado(EstadoInspeccion.enRealizacion);
      inspecciones.add(i);
      i = new Inspeccion(4, fechaInicio, null, null, null, null, null, null);
      i.setEstado(EstadoInspeccion.enRealizacion);
      inspecciones.add(i);
      InspeccionNotifier inspeccionNotifier = InspeccionNotifier();
      inspeccionNotifier.inspeccionList = inspecciones;
      expect(inspecciones[0].id, 1);
      expect(inspecciones[1].id, 2);
      expect(inspecciones[2].id, 3);
      expect(inspecciones[3].id, 4);
      inspecciones = ordenarInspecciones(inspeccionNotifier);
      expect(inspecciones[0].id, 2);
      expect(inspecciones[1].id, 3);
      expect(inspecciones[2].id, 4);
      expect(inspecciones[3].id, 1);
    });

    test('ordenar provincias alfabeticamente', () async {
      List<Provincia> provincias = [];
      List<String> provinciasOrd = [];
      provincias.add(new Provincia("Valladolid"));
      provincias.add(new Provincia("León"));
      provincias.add(new Provincia("Zamora"));
      provincias.add(new Provincia("Burgos"));
      expect(provincias[0].provincia, "Valladolid");
      expect(provincias[1].provincia, "León");
      expect(provincias[2].provincia, "Zamora");
      expect(provincias[3].provincia, "Burgos");
      InspeccionNotifier inspeccionNotifier = InspeccionNotifier();
      inspeccionNotifier.provinciaList = provincias;
      provinciasOrd = ordenarProvincias(inspeccionNotifier);
      expect(provinciasOrd[0], "Burgos");
      expect(provinciasOrd[1], "León");
      expect(provinciasOrd[2], "Valladolid");
      expect(provinciasOrd[3], "Zamora");
    });

    test('calcular id evaluacion', () async {
      List<Evaluacion> evaluaciones = [];
      evaluaciones.add(new Evaluacion(1, 0, 0, "a", "a", "Potencial", 0, 0, 0, "a", "a", "a"));
      evaluaciones.add(new Evaluacion(2, 0, 0, "a", "a", "Potencial", 0, 0, 0, "a", "a", "a"));
      evaluaciones.add(new Evaluacion(3, 0, 0, "a", "a", "Potencial", 0, 0, 0, "a", "a", "a"));
      evaluaciones.add(new Evaluacion(4, 0, 0, "a", "a", "Potencial", 0, 0, 0, "a", "a", "a"));
      EvaluacionRiesgoNotifier evaluacionRiesgoNotifier = EvaluacionRiesgoNotifier();
      evaluacionRiesgoNotifier.evaluacionList = evaluaciones;
      int id = calcularIdEvaluacion(evaluacionRiesgoNotifier);
      expect(id, 5);
    });

    test('calcular id riesgo', () async {
      List<SubRiesgo> riesgos = [];
      riesgos.add(new SubRiesgo(0, "a", "a", 0, 1));
      riesgos.add(new SubRiesgo(0, "a", "a", 0, 2));
      riesgos.add(new SubRiesgo(0, "a", "a", 0, 3));
      riesgos.add(new SubRiesgo(0, "a", "a", 0, 4));
      RiesgoInspeccionEliminadaNotifier riesgoInspeccionEliminadaNotifier = RiesgoInspeccionEliminadaNotifier();
      riesgoInspeccionEliminadaNotifier.riesgoList = riesgos;
      int id = calcularIdRiesgo(riesgoInspeccionEliminadaNotifier);
      expect(id, 5);
    });

    test('calcular id inspeccion', () async {
      List<Inspeccion> inspecciones = [];
      inspecciones.add(new Inspeccion(1, null, null, null, null, null, null, null));
      inspecciones.add(new Inspeccion(2, null, null, null, null, null, null, null));
      inspecciones.add(new Inspeccion(3, null, null, null, null, null, null, null));
      inspecciones.add(new Inspeccion(4, null, null, null, null, null, null, null));
      InspeccionNotifier inspeccionNotifier = InspeccionNotifier();
      inspeccionNotifier.inspeccionList = inspecciones;
      int id = calcularIdInspeccion(inspeccionNotifier);
      expect(id, 5);
    });

    test('calculoNP', () {
      final nivelDeficiencia = 2;
      final nivelExposicion = 3;

      expect(calculoNP(nivelDeficiencia, nivelExposicion), equals(6));
    });

    test('calculoNR', () {
      final nivelConsecuencias = 60;
      final nivelP = 18; // valor posible de NP

      expect(calculoNR(nivelConsecuencias, nivelP), equals(1080));
    });
  });
}
