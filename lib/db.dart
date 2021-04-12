import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tfg/modelo/user.dart';
import 'package:tfg/notifier/user_notifier.dart';
import 'modelo/user.dart';
import 'notifier/auth_notifier.dart';

FirebaseAuth _auth; // = FirebaseAuth.instance;
FirebaseFirestore _db; // = FirebaseFirestore.instance;
QuerySnapshot response;

Db() {
  _auth = FirebaseAuth.instance;
  _db = FirebaseFirestore.instance;
}

Future<Usuario> getUsuarioPorEmail(String email) async {
  Usuario usuario;
  FirebaseFirestore.instance
      .collection('usuario')
      .where('email', isEqualTo: email)
      .get()
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      print(doc['dni']);
      usuario = new Usuario(
          doc['email'], null, doc['numero'], doc['dni'], doc['nombre']);
      print(usuario.getPhone());
      return usuario;
    });
  });
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

signout(AuthNotifier authNotifier) async {
  await FirebaseAuth.instance
      .signOut()
      .catchError((error) => print(error.code));

  authNotifier.setUser(null);
}

registrarUsuario(Usuario u, AuthNotifier authNotifier) async {
  _auth
      .createUserWithEmailAndPassword(
        email: u.getEmail(),
        password: u.getPassword(),
      )
      .catchError((error) => print(error.code));
  Map<String, dynamic> demoData = {
    "email": u.getEmail(),
    "numero": u.getPhone(),
    "dni": u.getDni(),
    "nombre": u.getNombre()
  };
  User currentUser = await FirebaseAuth.instance.currentUser;
  authNotifier.setUser(currentUser);
  //AÑADE A LA COLECCION data UNA NUEVA INSTANCIA CON DOS DATOS UNO name Y OTRO moto CUYOS VALORES ESTAN DEFINIDOS ENCIMA
  //ESTO SE PODRIA METER EN UNA FUNCION PARA EL LOGIN POR EJEMPLO
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('usuario');
  collectionReference.add(demoData);
}

modificarUsuario(String email, String numero, String nombre,
    String id) async {
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
