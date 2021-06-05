
class Usuario {
  //String name;
  String email, password, url, phone, dni, nombreCompleto, id, tipo;


  Usuario(String email, String password, String phone, String dni, String nombreCompleto, String url, String tipo){
    this.email = email;
    this.nombreCompleto = nombreCompleto;
    //this.name,
    this.phone = phone;
    this.dni = dni;
    this.password = password;
    this.url = url;
    this.tipo = tipo;
  }

  Usuario.fromMap(Map<String, dynamic> data) {
    email = data['email'];
    phone = data['numero'];
    dni = data['dni'];
    url = data['url'];
    nombreCompleto = data['nombre'];
    tipo = data['tipo'];
    password = data['contraseña'];
  }

  String getNumero(){
    return phone;
  }

  void setNumero(String p){
    phone = p;
  }

  void setPass(String p){
    password = p;
  }
  
  String getEmail(){
    return email;
  }

  String getId(){
    return id;
  }

  String getNombre(){
    return nombreCompleto;
  }

  String getPassword(){
    return password;
  }

  String getPhone(){
    return phone;
  }

  String getDni(){
    return dni;
  }

  void setNombre(String nombre) {
    nombreCompleto = nombre;
  }

  void setEmail(String em) {
    email = em;
  }

  void setId(String i) {
    id = i;
  }
}