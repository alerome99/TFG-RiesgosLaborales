class Riesgo {

  int id;
  String nombre;
  String icono;

  /*
  static const _NOMBRE_ = "nombre";
  static const _ID_ = "id";
  static const _ICONO_ = "icono";


  Riesgo({
    this.id,
    this.nombre,
    this.icono,
  });

  factory Riesgo.fromJson(Map<String, dynamic> json) => Riesgo(
      id        : json[_ID_],
      nombre    : json[_NOMBRE_],
      icono     : json[_ICONO_],
  );
  */

  Riesgo(int id, String nombre, String icono){
    this.id = id;
    this.nombre = nombre;
    this.icono = icono;
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