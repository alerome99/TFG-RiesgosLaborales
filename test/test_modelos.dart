import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test/test.dart';
import 'package:tfg/modelo/evaluacion.dart';
import 'package:tfg/modelo/inspeccion.dart';
import 'package:tfg/modelo/subRiesgo.dart';
import 'package:tfg/modelo/user.dart';

void main() {
  group('Metodo from map', () {
    test('riesgo', () async {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('riesgo')
        .where('idInspeccion', isEqualTo: 1)
        .get();
      snapshot.docs.forEach((document) {
        SubRiesgo r = SubRiesgo.fromMap(document.data());
        expect(r.idUnica, 1);
      });
    });

    test('evaluacion', () async {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('evaluacion')
        .where('id', isEqualTo: 11)
        .get();
      snapshot.docs.forEach((document) {
        Evaluacion e = Evaluacion.fromMap(document.data());
        expect(e.id, 11);
      });
    });

    test('fotoRiesgo', () async {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('fotoRiesgo')
        .where('idRiesgo', isEqualTo: 15)
        .get();
      snapshot.docs.forEach((document) {
        FotoRiesgo f = FotoRiesgo.fromMap(document.data());
        expect(f.idRiesgoUnica, 15);
      });
    });

    test('usuario', () async {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('usuario')
        .where('dni', isEqualTo: "22222222S")
        .get();
      snapshot.docs.forEach((document) {
        Usuario u = Usuario.fromMap(document.data());
        expect(u.dni, "22222222S");
      });
    });

    test('inspeccion', () async {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('inspeccion')
        .where('id', isEqualTo: 3)
        .get();
      snapshot.docs.forEach((document) {
        Inspeccion i = Inspeccion.fromMap(document.data());
        expect(i.id, 3);
      });
    });
  });
}
