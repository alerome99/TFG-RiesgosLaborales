
class Inspeccion {
  String id;
  DateTime fechaInicio;
  DateTime fechaFin;
  String lugar;
  String provincia;
  double latitud;
  double longitud;
  String descripcion;
  String titulo;

  Inspeccion(String id, DateTime fechaInicio, DateTime fechaFin, String lugar, String provincia, double latitud, double longitud, String descripcion, String titulo){
    this.id = id;
    this.fechaInicio = fechaInicio;
    this.fechaFin = fechaFin;
    this.lugar = lugar;
    this.provincia = provincia;
    this.latitud = latitud;
    this.longitud = longitud;
    this.descripcion = descripcion;
    this.titulo = titulo;
  }

  Inspeccion.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    fechaInicio = data['fechaInicio'];
    fechaFin = data['fechaFin'];
    lugar = data['lugar'];
    provincia = data['provincia'];
    latitud = data['latitud'];
    longitud = data['longitud'];
    descripcion = data['descripcion'];
    titulo = data['titulo'];
  }

  String getId(){
    return id;
  }

  void setId(String id){
    this.id = id;
  }

  DateTime getFechaInicio(){
    return fechaInicio;
  } 

  void setFechaInicio(DateTime fi){
    fechaInicio = fi;
  }

  DateTime getFechaFin(){
    return fechaFin;
  }

  void setFechaFin(DateTime ff){
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