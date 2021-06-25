class Informacion {
  String idRiesgoPadre,
      idRiesgo,
      nombreRiesgo,
      tipoFactor,
      nivelDeficiencia,
      nivelExposicion,
      nivelConsecuencia,
      total,
      latitud,
      longitud,
      altitud,
      accionCorrectora,
      url;
  Informacion(
      String idRiesgoPadre,
      String idRiesgo,
      String nombreRiesgo,
      String tipoFactor,
      String nivelDeficiencia,
      String nivelExposicion,
      String nivelConsecuencia,
      String total,
      String latitud,
      String longitud,
      String altitud,
      String accionCorrectora,
      String url) {
        this.idRiesgoPadre = idRiesgoPadre;
        this.idRiesgo = idRiesgo;
        this.nombreRiesgo = nombreRiesgo;
        this.tipoFactor = tipoFactor;
        this.nivelDeficiencia = nivelDeficiencia;
        this.nivelExposicion = nivelExposicion;
        this.nivelConsecuencia = nivelConsecuencia;
        this.total = total;
        this.latitud = latitud;
        this.longitud = longitud;
        this.altitud = altitud;
        this.accionCorrectora = accionCorrectora;
        this.url = url;
      }
}
