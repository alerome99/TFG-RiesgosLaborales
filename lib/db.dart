import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user.dart';

class Db {

    FirebaseAuth _auth;// = FirebaseAuth.instance;
    FirebaseFirestore _db;// = FirebaseFirestore.instance;

  Db (){
    _auth = FirebaseAuth.instance;
    _db = FirebaseFirestore.instance;
  }

  /*
    Db (){
      Firebase.initializeApp();
      mAuth = FirebaseAuth.instance;
      db = FirebaseFirestore.instance;
    }*/

    Future<void> iniciarSesion(Usuario u)  async {
      await _auth.signInWithEmailAndPassword(
              email: u.getEmail(),
              password: u.getPassword(),
            );
    }

    Future<void> registrarUsuario(Usuario u)  async {
      await _auth.createUserWithEmailAndPassword(
              email: u.getEmail(),
              password: u.getPassword(),
            );
      Map<String, dynamic> demoData = { "email" : u.getEmail(),
      "numero" : u.getPhone(),
      "dni" : u.getDni(),
      "nombre" : u.getNombre()};
      //AÑADE A LA COLECCION data UNA NUEVA INSTANCIA CON DOS DATOS UNO name Y OTRO moto CUYOS VALORES ESTAN DEFINIDOS ENCIMA
      //ESTO SE PODRIA METER EN UNA FUNCION PARA EL LOGIN POR EJEMPLO
      CollectionReference collectionReference = FirebaseFirestore.instance.collection('usuario');
      collectionReference.add(demoData);
    }

    User getCurrentUser(){
      return _auth.currentUser;
    }
     /*
    String getEmailCurrentUser(){
      return _auth.currentUser.email;
    }*/
}