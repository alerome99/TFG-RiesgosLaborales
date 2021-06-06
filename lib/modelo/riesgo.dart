class Riesgo {

  int id;
  String nombre, icono;

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