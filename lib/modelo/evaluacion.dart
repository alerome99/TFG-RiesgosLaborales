enum TipoFactor{
  Potencial,
  Existente,
}

class FotoEvaluacion{
  String path, idDocumento, url;
  int idEvaluacionUnica;
  bool eliminada;

  FotoEvaluacion(String path, int idEvaluacionUnica){
    this.path = path;
    this.idEvaluacionUnica = idEvaluacionUnica;
    this.eliminada = false;
  }

  void setIdDocumento(String id){
    idDocumento = id;
  }

  String getIdDocumento(){
    return idDocumento;
  }

  FotoEvaluacion.fromMap(Map<String, dynamic> data) {
    eliminada = data['eliminada'];
    idEvaluacionUnica = data['idEvaluacion'];
    url = data['url'];
  }
}

class Evaluacion {
  String titulo, accionCorrectora, tp, idDocumento;
  TipoFactor tipo;
  int id, idRiesgo, idInspeccion, nivelExposicion, nivelDeficiencia, nivelConsecuencias;
  Evaluacion(int id, int idRiesgo, int idInspeccion, String titulo, String accionCorrectora, String tp, int nivelDeficiencia, int nivelExposicion, int nivelConsecuencias){
    this.id = id;
    this.idRiesgo = idRiesgo;
    this.idInspeccion = idInspeccion;
    this.accionCorrectora = accionCorrectora;
    this.titulo = titulo;
    if(tp == "Potencial"){
      tipo = TipoFactor.Potencial;
    }else{
      tipo = TipoFactor.Existente;
    }
    this.nivelConsecuencias = nivelConsecuencias;
    this.nivelDeficiencia = nivelDeficiencia;
    this.nivelExposicion = nivelExposicion;
  }

  Evaluacion.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    tp = data['tipoFactor'];
    if(tp == "Potencial"){
      tipo = TipoFactor.Potencial;
    }
    if(tp == "Existente"){
      tipo = TipoFactor.Existente;
    }
    titulo = data['titulo'];
    idInspeccion = data['idInspeccion'];
    idRiesgo = data['idRiesgo'];
    accionCorrectora = data['accionCorrectora'];
    nivelConsecuencias = data['nivelConsecuencias'];
    nivelDeficiencia = data['nivelDeficiencia'];
    nivelExposicion = data['nivelExposicion'];
  }

  void setIdDocumento(String id){
    idDocumento = id;
  }

  String getIdDocumento(){
    return idDocumento;
  }
}