class SubRiesgo {

  int id;
  String nombre, idDocumento;
  String icono;
  int idRiesgoPadre;
  bool eliminado;

  SubRiesgo(int id, String nombre, String icono, int idRiesgoPadre){
    this.id = id;
    this.nombre = nombre;
    this.icono = icono;
    this.idRiesgoPadre = idRiesgoPadre;
    eliminado = false;
  }

  SubRiesgo.fromMap(Map<String, dynamic> data) {
    nombre = data['nombre'];
    icono = data['icono'];
    eliminado = data['eliminado'];
  }

  bool getEliminado(){
    return eliminado;
  }

  void setEliminado(){
    eliminado = true;
  }

  void setIdRiesgoPadre(int irp){
    idRiesgoPadre = irp;
  }

  String getIdDocumento(){
    return idDocumento;
  }

  void setIdDocumento(String id){
    idDocumento = id;
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