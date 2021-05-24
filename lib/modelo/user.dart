
class Usuario {
  String email;
  //String name;
  String password;
  String phone;
  String dni;
  String nombreCompleto;
  String id;
  String url;

  Usuario(String email, String password, String phone, String dni, String nombreCompleto, String url){
    this.email = email;
    this.nombreCompleto = nombreCompleto;
    //this.name,
    this.phone = phone;
    this.dni = dni;
    this.password = password;
    this.url = url;
  }

  Usuario.fromMap(Map<String, dynamic> data) {
    email = data['email'];
    phone = data['numero'];
    dni = data['dni'];
    url = data['url'];
    nombreCompleto = data['nombre'];
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