class SubRiesgo {

  int id;
  String nombre;
  String icono;
  int idRiesgoPadre;

  SubRiesgo(int id, String nombre, String icono, int idRiesgoPadre){
    this.id = id;
    this.nombre = nombre;
    this.icono = icono;
    this.idRiesgoPadre = idRiesgoPadre;
  }

  void setIdRiesgoPadre(int irp){
    idRiesgoPadre = irp;
  }

  int getIdRiesgoPadre(){
    return idRiesgoPadre;
  }
  
  void setId(int i){
    id = i;
  }

  int getId(){
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