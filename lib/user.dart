import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Usuario with ChangeNotifier{
  String id;
  String name;
  String email;

  Usuario({
    this.id,
    this.name,
    this.email,
  });

  factory Usuario.fromFirestore(DocumentSnapshot userDoc){
    Map userData = userDoc.data as Map;
    return Usuario(
      id: userDoc.id,
      name: userData['name'],
      email: userData['email'],
    );
  }

  void setFromFireStore(DocumentSnapshot userDoc){
    Map userData = userDoc.data as Map;
    this.id = userDoc.id;
    this.name = userData['name'];
    this.email = userData['email'];
    notifyListeners();
  }
}