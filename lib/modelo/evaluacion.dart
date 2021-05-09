enum TipoFactor{
  Potencial,
  Existente,
}

class Evaluacion {
  String titulo, accionCorrectora;
  TipoFactor tipo;
  int id, idRiesgo, idInspeccion;
  double nivelExposion, nivelDeficiencia, nivelConsecuencias;
  Evaluacion(int id, int idRiesgo, int idInspeccion, String titulo, String accionCorrectora, String tp, double nivelDeficiencia, double nivelExposicion, double nivelConsecuencias){
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
    this.nivelExposion = nivelExposion;
  }

  Evaluacion.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    titulo = data['titulo'];
    idInspeccion = data['idInspeccion'];
    idRiesgo = data['idRiesgo'];
    accionCorrectora = data['accionCorrectora'];
    nivelConsecuencias = data['nivelConsecuencias'];
    nivelDeficiencia = data['nivelDeficiencia'];
    nivelExposion = data['nivelExposicion'];
  }
}