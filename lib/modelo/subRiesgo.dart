class SubRiesgo {

  int id, idUnica;
  String nombre, idDocumento;
  String icono;
  int idRiesgoPadre;
  bool eliminado, evaluado;

  SubRiesgo(int id, String nombre, String icono, int idRiesgoPadre, int idUnica){
    this.id = id;
    this.idUnica = idUnica;
    this.nombre = nombre;
    this.icono = icono;
    this.idRiesgoPadre = idRiesgoPadre;
    eliminado = false;
    evaluado = false;
  }



  SubRiesgo.fromMap(Map<String, dynamic> data) {
    nombre = data['nombre'];
    icono = data['icono'];
    eliminado = data['eliminado'];
    id = data['id'];
    idUnica = data['idUnica'];
    evaluado = data['evaluado'];
  }

  int getIdUnica(){
    return idUnica;
  }

  void setIdUnica(int id){
    idUnica = id;
  }

  bool getEliminado(){
    return eliminado;
  }

  void setEliminado(){
    eliminado = true;
  }

  bool getEvaluado(){
    return evaluado;
  }

  void setEvaluado(){
    evaluado = true;
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