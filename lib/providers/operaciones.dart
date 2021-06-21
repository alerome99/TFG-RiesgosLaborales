import 'package:tfg/modelo/inspeccion.dart';
import 'package:tfg/notifiers/evaluacionRiesgo_notifier.dart';
import 'package:tfg/notifiers/inspeccion_notifier.dart';
import 'package:tfg/notifiers/riesgoInspeccionEliminada_notifier.dart';

List<Inspeccion> ordenarInspecciones(InspeccionNotifier inspeccionNotifier) {
  List<Inspeccion> inspecciones = new List<Inspeccion>();
  List<Inspeccion> inspecciones2 = new List<Inspeccion>();
  for (int i = 0; i < inspeccionNotifier.inspeccionList.length; i++) {
    if (inspeccionNotifier.inspeccionList[i].estado ==
        EstadoInspeccion.enRealizacion) {
      inspecciones.add(inspeccionNotifier.inspeccionList[i]);
    }
  }
  for (int i = 0; i < inspeccionNotifier.inspeccionList.length; i++) {
    if (inspeccionNotifier.inspeccionList[i].estado ==
        EstadoInspeccion.pendiente) {
      inspecciones2.add(inspeccionNotifier.inspeccionList[i]);
    }
  }
  inspecciones.sort((a, b) {
    return a.fechaInicio.compareTo(b.fechaInicio);
  });
  inspecciones2.sort((a, b) {
    return a.fechaInicio.compareTo(b.fechaInicio);
  });
  for (int i = 0; i < inspecciones2.length; i++) {
    inspecciones.add(inspecciones2[i]);
  }
  return inspecciones;
}

List<String> ordenarProvincias(InspeccionNotifier inspeccionNotifier) {
  List<String> listaProvincias = [];
  inspeccionNotifier.provinciaList.forEach((provincia) {
    listaProvincias.add(provincia.provincia);
  });
  listaProvincias.sort();
  return listaProvincias;
}

int calcularIdEvaluacion(EvaluacionRiesgoNotifier evaluacionRiesgoNotifier) {
  int idNueva = 0;
  if (evaluacionRiesgoNotifier.evaluacionList.length != 0) {
    for (int j = 0; j < evaluacionRiesgoNotifier.evaluacionList.length; j++) {
      if (idNueva <= evaluacionRiesgoNotifier.evaluacionList[j].id) {
        idNueva = evaluacionRiesgoNotifier.evaluacionList[j].id + 1;
      }
    }
  }
  return idNueva;
}

int calcularIdRiesgo(
    RiesgoInspeccionEliminadaNotifier riesgoInspeccionEliminadaNotifier) {
  int idNueva = 0;
  if (riesgoInspeccionEliminadaNotifier.riesgoList.length != 0) {
    for (int i = 0;
        i < riesgoInspeccionEliminadaNotifier.riesgoList.length;
        i++) {
      if (idNueva <= riesgoInspeccionEliminadaNotifier.riesgoList[i].idUnica) {
        idNueva = riesgoInspeccionEliminadaNotifier.riesgoList[i].idUnica + 1;
      }
    }
  }
  return idNueva;
}

int calcularIdInspeccion(InspeccionNotifier inspeccionNotifier) {
  int idNueva = 0;
  if (inspeccionNotifier.inspeccionList.length != 0) {
    for (int j = 0; j < inspeccionNotifier.inspeccionList.length; j++) {
      if (idNueva <= inspeccionNotifier.inspeccionList[j].id) {
        idNueva = inspeccionNotifier.inspeccionList[j].id + 1;
      }
    }
  }
  return idNueva;
}

int calculoNP(int nivelDeficiencia, int nivelExposicion) {
  return nivelDeficiencia * nivelExposicion;
}

int calculoNR(int nivelConsecuencias, int nivelP) {
  return nivelConsecuencias * nivelP;
}
