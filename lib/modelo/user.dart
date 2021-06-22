
class Usuario {
  String email, password, url, telefono, dni, nombreCompleto, id, tipo, idDocumento, motivo, direccion;
  bool baja;


  Usuario(String email, String password, String telefono, String dni, String nombreCompleto, String url, String tipo, String direccion){
    this.email = email;
    this.nombreCompleto = nombreCompleto;
    this.telefono = telefono;
    this.dni = dni;
    this.password = password;
    this.url = url;
    this.tipo = tipo;
    this.direccion = direccion;
    baja = false;
    motivo = null;
  }

  Usuario.fromMap(Map<String, dynamic> data) {
    email = data['email'];
    telefono = data['numero'];
    dni = data['dni'];
    url = data['url'];
    nombreCompleto = data['nombre'];
    tipo = data['tipo'];
    password = data['contraseña'];
    baja = data['baja'];
    motivo = data['motivo'];
    direccion = data['direccion'];
  }


  String getDireccion(){
    return direccion;
  }

  void setDireccion(String d){
    direccion = d;
  }

  String getNumero(){
    return telefono;
  }

  String getMotivo(){
    return motivo;
  }

  bool getBaja(){
    return baja;
  }

  void setBaja(bool b){
    baja = b;
  }

  void setMotivo(String m){
    motivo = m;
  }

  void setIdDocumento(String i){
    idDocumento = i;
  }

  String getIdDocumento(){
    return idDocumento;
  }

  void setNumero(String p){
    telefono = p;
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
    return telefono;
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