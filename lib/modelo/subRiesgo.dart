class SubRiesgo {

  int id, idUnica;
  String nombre, idDocumento, icono;
  int idRiesgoPadre, total;
  bool eliminado, evaluado;

  SubRiesgo(int id, String nombre, String icono, int idRiesgoPadre, int idUnica){
    this.id = id;
    total = 0;
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
    idRiesgoPadre = data['idRiesgoPadre'];
    idUnica = data['idUnica'];
    evaluado = data['evaluado'];
    total = data['total'];
  }

  void setIdUnica(int id){
    idUnica = id;
  }

  void setEliminado(){
    eliminado = true;
  }

  String getIdDocumento(){
    return idDocumento;
  }

  void setIdDocumento(String id){
    idDocumento = id;
  }
}