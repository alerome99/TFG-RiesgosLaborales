
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tfg/modelo/subRiesgo.dart';

enum EstadoInspeccion { 
   enRealizacion, 
   cerrada
}

class Inspeccion {
  int id;
  Timestamp fechaInicio, fechaFin;
  double latitud, longitud;
  String descripcion, idDocumento, titulo, provincia, lugar, nombreEmpresa;
  EstadoInspeccion estado;
  List<SubRiesgo> subRiesgos;

  Inspeccion(int id, Timestamp fechaInicio, Timestamp fechaFin, String lugar, String provincia, String descripcion, String titulo, String nombreEmpresa){
    this.id = id;
    estado = EstadoInspeccion.enRealizacion;
    this.fechaInicio = fechaInicio;
    this.fechaFin = fechaFin;
    this.lugar = lugar;
    this.provincia = provincia;
    this.descripcion = descripcion;
    subRiesgos = [];
    this.titulo = titulo;
    this.nombreEmpresa = nombreEmpresa;
  }

  Inspeccion.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    String estadoTem = data['estado'];
    if(estadoTem == "cerrada"){
      estado = EstadoInspeccion.cerrada;
    }
    if(estadoTem == "enRealizacion"){
      estado = EstadoInspeccion.enRealizacion;
    }
    fechaInicio = data['fechaInicio'];
    fechaFin = data['fechaFin'];
    lugar = data['lugar'];
    provincia = data['provincia'];
    descripcion = data['descripcion'];
    titulo = data['titulo'];
    nombreEmpresa = data['nombreEmpresa'];
  }

  String getIdDocumento(){
    return idDocumento;
  }

  void setEstado(EstadoInspeccion ei){
    estado = ei;
  }

  void setIdDocumento(String id){
    idDocumento = id;
  }
}

class Provincia {

    String id;
    String provincia;
    Provincia(String provincia){
      this.provincia = provincia;
    }
    
    Provincia.fromMap(Map<String, dynamic> data) {
      id = data['id'];
      provincia = data['provincia'];
    }
}