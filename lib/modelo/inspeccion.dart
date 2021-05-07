
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tfg/modelo/subRiesgo.dart';

enum EstadoInspeccion { 
   enRealizacion, 
   pendiente, 
   cerrada
}

class Inspeccion {
  int id;
  Timestamp fechaInicio;
  Timestamp fechaFin;
  String lugar;
  String provincia;
  double latitud;
  double longitud;
  String descripcion;
  String titulo;
  EstadoInspeccion estado;
  List<SubRiesgo> subRiesgos;

  Inspeccion(int id, Timestamp fechaInicio, Timestamp fechaFin, String lugar, String provincia, double latitud, double longitud, String descripcion, String titulo){
    this.id = id;
    estado = EstadoInspeccion.enRealizacion;
    this.fechaInicio = fechaInicio;
    this.fechaFin = fechaFin;
    this.lugar = lugar;
    this.provincia = provincia;
    this.latitud = latitud;
    this.longitud = longitud;
    this.descripcion = descripcion;
    subRiesgos = [];
    this.titulo = titulo;
  }

  Inspeccion.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    estado = data['estado'];
    fechaInicio = data['fechaInicio'];
    fechaFin = data['fechaFin'];
    lugar = data['lugar'];
    provincia = data['provincia'];
    latitud = data['latitud'];
    longitud = data['longitud'];
    descripcion = data['descripcion'];
    titulo = data['titulo'];
  }

  List<SubRiesgo> getRiesgos(){
    return subRiesgos;
  }

  void addRiesgo(SubRiesgo sr){
    subRiesgos.add(sr);
  }

  void delRiesgo(int id){
    for (int i = 0; i < subRiesgos.length; i++){
      if(subRiesgos[i].id == id){
        subRiesgos.remove(i);
      }
    }
  }

  int getNumeroRiesgos(){
    return subRiesgos.length;
  }

  int getId(){
    return id;
  }

  void setId(int id){
    this.id = id;
  }

  EstadoInspeccion getEstado(){
    return estado;
  }

  void setEstado(EstadoInspeccion ei){
    estado = ei;
  }

  Timestamp getFechaInicio(){
    return fechaInicio;
  } 

  void setFechaInicio(Timestamp fi){
    fechaInicio = fi;
  }

  Timestamp getFechaFin(){
    return fechaFin;
  }

  void setFechaFin(Timestamp ff){
    fechaFin = ff;
  }

  String getLugar(){
    return lugar;
  }

  void setLugar(String l){
    lugar = l;
  }
  
  String getProvincia(){
    return provincia;
  }

  void setProvincia(String p){
    provincia = p;
  }

  double getLatitud(){
    return latitud;
  }

  void setLatitud(double lat){
    latitud = lat;
  }

  double getLongitud(){
    return longitud;
  }

  void setLongitud(double lon){
    longitud = lon;
  }

  String getDescripcion(){
    return descripcion;
  }

  void setDescripcion(String d){
    descripcion = d;
  }

  String getTitulo(){
    return titulo;
  }

  void setTitulo(String t){
    titulo = t;
  }
}

class Provincia {

    String id;
    String provincia;

    Provincia.fromMap(Map<String, dynamic> data) {
      id = data['id'];
      provincia = data['provincia'];
    }

    Map<String, dynamic> toJson() => {
      "id": id,
      "provincia": provincia,
    };
}