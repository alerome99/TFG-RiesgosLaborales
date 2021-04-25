class SubRiesgo {

  String id;
  String nombre;
  String icono;
  String idRiesgoPadre;

  SubRiesgo(String id, String nombre, String icono, String idRiesgoPadre){
    this.id = id;
    this.nombre = nombre;
    this.icono = icono;
    this.idRiesgoPadre = idRiesgoPadre;
  }

  void setIdRiesgoPadre(String irp){
    idRiesgoPadre = irp;
  }

  String getIdRiesgoPadre(){
    return idRiesgoPadre;
  }
  
  void setId(String i){
    id = i;
  }

  String getId(){
    return id;
  }

  void setNombre(String n){
    nombre = n;
  }

  String getNombre(){
    return nombre;
  }

  void setIcono(String ic){
    icono = ic;
  }

  String getIcono(){
    return icono;
  }
}