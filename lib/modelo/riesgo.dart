class Riesgo {

  String id;
  String nombre;
  String icono;

  Riesgo(String id, String nombre, String icono){
    this.id = id;
    this.nombre = nombre;
    this.icono = icono;
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