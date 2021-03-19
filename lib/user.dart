import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Usuario {
  String email;
  //String name;
  String pass;

  Usuario(String email, String pass){
    this.email = email;
    //this.name,
    this.pass = pass;
  }

  String getEmail(){
    return email;
  }

  String getPassword(){
    return pass;
  }

  /*
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
  }*/
}