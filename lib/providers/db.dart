import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tfg/modelo/evaluacion.dart';
import 'package:tfg/modelo/subRiesgo.dart';
import 'package:tfg/modelo/user.dart';
import 'package:tfg/notifiers/inspeccion_notifier.dart';
import 'package:tfg/notifiers/riesgoInspeccionEliminada_notifier.dart';
import 'package:tfg/notifiers/riesgosInspeccion_notifier.dart';
import 'package:tfg/notifiers/subRiesgo_notifier.dart';
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

addInspeccion(Inspeccion i, InspeccionNotifier inspeccionNotifier) async{
    Map<String, dynamic> demoData = {
      "id": i.getId(),
      "descripcion": i.getDescripcion(),
      "titulo": i.getTitulo(),
      "fechaFin": i.getFechaFin(),
      "fechaInicio": i.getFechaInicio(),
      "provincia": i.getProvincia(),
      "lugar": i.getLugar(),
      "estado": i.getEstado(),
      "nombreEmpresa": i.getNombreEmpresa(),
    };
    CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('inspeccion');
    collectionReference.add(demoData);
    inspeccionNotifier.currentInspeccion = i;
}

addRiesgo(SubRiesgo sr, InspeccionNotifier inspeccionNotifier) async{
    Map<String, dynamic> demoData = {
      "idInspeccion": inspeccionNotifier.currentInspeccion.id,
      "icono": sr.icono,
      "id": sr.id,
      "nombre": sr.nombre,
      "eliminado": false,
      "evaluado": false,
    };
    CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('riesgo');
    collectionReference.add(demoData);
}

addEvaluacion(Evaluacion evaluacion) async{
    Map<String, dynamic> demoData = {
      "id": evaluacion.id,
      "titulo": evaluacion.titulo,
      "idInspeccion": evaluacion.idInspeccion,
      "idRiesgo": evaluacion.idRiesgo,
      "accionCorrectora": evaluacion.accionCorrectora,
      "nivelConsecuencias": evaluacion.nivelConsecuencias,
      "nivelDeficiencia": evaluacion.nivelDeficiencia,
      "nivelExposicion": evaluacion.nivelExposicion,
    };
    CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('evaluacion');
    collectionReference.add(demoData);
}

getRiesgosInspeccionNoEliminados(RiesgoInspeccionNotifier riesgoInspeccionNotifier, InspeccionNotifier inspeccionNotifier) async{
  QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('riesgo')
    .where('idInspeccion', isEqualTo: inspeccionNotifier.currentInspeccion.id).where('eliminado', isEqualTo:false).where('evaluado', isEqualTo:false)
    .get();
  List<SubRiesgo> riesgoList = [];
  snapshot.docs.forEach((document) {
    SubRiesgo r = SubRiesgo.fromMap(document.data());
    r.setIdDocumento(document.id);
    riesgoList.add(r);
  });
  riesgoInspeccionNotifier.riesgoList = riesgoList;
}

getRiesgosInspeccionTodos(RiesgoInspeccionEliminadaNotifier riesgoInspeccionEliminadaNotifier, InspeccionNotifier inspeccionNotifier) async{
  QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('riesgo')
    .where('idInspeccion', isEqualTo: inspeccionNotifier.currentInspeccion.id).where('evaluado', isEqualTo:false)
    .get();
  List<SubRiesgo> riesgoList = [];
  snapshot.docs.forEach((document) {
    SubRiesgo r = SubRiesgo.fromMap(document.data());
    r.setIdDocumento(document.id);
    riesgoList.add(r);
  });
  riesgoInspeccionEliminadaNotifier.riesgoList = riesgoList;
}

modificarUsuario(String email, String numero, String nombre, String id) async {
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('usuario');
  collectionReference
      .doc(id)
      .update({'email': email, 'numero': numero, 'nombre': nombre});
}
marcarRiesgoComoEvaluado(bool evaluado, SubRiesgo sr) async {
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('riesgo');
  collectionReference
      .doc(sr.getIdDocumento())
      .update({'evaluado': evaluado});
}

actualizarRiesgo(bool estado, SubRiesgo sr) async {
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('riesgo');
  collectionReference
      .doc(sr.getIdDocumento())
      .update({'eliminado': estado});
}

modificarEstadoComoPendienteInspeccion(String id) async{
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('inspeccion');
  collectionReference
      .doc(id)
      .update({'estado': "pendiente", 'fechaFin': Timestamp.now()});  
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

getInspecciones(InspeccionNotifier inspeccionNotifier) async {
  QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('inspeccion').get();
  List<Inspeccion> inspeccionesList = [];
  snapshot.docs.forEach((document) {
    Inspeccion i = Inspeccion.fromMap(document.data());
    i.setIdDocumento(document.id);
    inspeccionesList.add(i);
  });
  inspeccionNotifier.inspeccionList = inspeccionesList;
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
