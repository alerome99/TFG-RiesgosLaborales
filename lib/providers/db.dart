import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tfg/modelo/user.dart';
import 'package:tfg/notifiers/inspeccion_notifier.dart';
import 'package:tfg/notifiers/user_notifier.dart';
import '../modelo/inspeccion.dart';
import '../modelo/user.dart';
import '../notifiers/auth_notifier.dart';

FirebaseAuth _auth; // = FirebaseAuth.instance;
QuerySnapshot response;

FirebaseFirestore _db; // = FirebaseFirestore.instance;

Db() {
  _auth = FirebaseAuth.instance;
  _db = FirebaseFirestore.instance;
}

login(Usuario user, AuthNotifier authNotifier) async {
  UserCredential authResult = await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: user.email, password: user.password)
      .catchError((error) => print(error.code));

  if (authResult != null) {
    User firebaseUser = authResult.user;

    if (firebaseUser != null) {
      print("Log In: $firebaseUser");
      authNotifier.setUser(firebaseUser);
    }
  }
}

initializeCurrentUser(AuthNotifier authNotifier) async {
  User firebaseUser = await FirebaseAuth.instance.currentUser;

  if (firebaseUser != null) {
    print(firebaseUser);
    authNotifier.setUser(firebaseUser);
  }
}

registrarUsuario(Usuario u, AuthNotifier authNotifier) async {
  UserCredential authResult = await FirebaseAuth.instance
      .createUserWithEmailAndPassword(
        email: u.getEmail(),
        password: u.getPassword(),
      )
      .catchError((error) => print(error.code));
  if (authResult != null) {
    User firebaseUser = authResult.user;
    if (firebaseUser != null) {
      print("Registered: $firebaseUser");
      Map<String, dynamic> demoData = {
        "email": u.getEmail(),
        "numero": u.getPhone(),
        "dni": u.getDni(),
        "nombre": u.getNombre()
      };
      //AÑADE A LA COLECCION data UNA NUEVA INSTANCIA CON DOS DATOS UNO name Y OTRO moto CUYOS VALORES ESTAN DEFINIDOS ENCIMA
      //ESTO SE PODRIA METER EN UNA FUNCION PARA EL LOGIN POR EJEMPLO
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection('usuario');
      collectionReference.add(demoData);
      authNotifier.setUser(firebaseUser);
    }
  }
}

modificarUsuario(String email, String numero, String nombre, String id) async {
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('usuario');
  collectionReference
      .doc(id)
      .update({'email': email, 'numero': numero, 'nombre': nombre});
}

User getCurrentUser() {
  return _auth.currentUser;
}

getUsers(UserNotifier userNotifier /*, String email*/) async {
  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('usuario').get();
  List<Usuario> userList = [];
  snapshot.docs.forEach((document) {
    Usuario user = Usuario.fromMap(document.data());
    userList.add(user);
  });

  userNotifier.userList = userList;
}

getProvincias(InspeccionNotifier inspeccionNotifier) async {
  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('provincia').get();
  List<Provincia> provinciaList = [];
  snapshot.docs.forEach((document) {
    Provincia p = Provincia.fromMap(document.data());
    provinciaList.add(p);
  });

  inspeccionNotifier.provinciaList = provinciaList;
}

getUser(UserNotifier userNotifier /*, String email*/) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('usuario')
      .where('email', isEqualTo: FirebaseAuth.instance.currentUser.email)
      .get();
  Usuario userT;
  snapshot.docs.forEach((document) {
    Usuario user = Usuario.fromMap(document.data());
    userT = user;
    userT.setId(document.id);
  });
  userNotifier.currentUser = userT;
}

setUserInic(Usuario u, UserNotifier userNotifier) async {
  userNotifier.currentUser = u;
}
