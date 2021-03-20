import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Usuario {
  String email;
  //String name;
  String pass;
  String phone;
  String dni;
  String nombreCompleto;

  Usuario(String email, String pass, String phone, String dni, String nombreCompleto){
    this.email = email;
    this.nombreCompleto = nombreCompleto;
    //this.name,
    this.phone = phone;
    this.dni = dni;
    this.pass = pass;
  }

  String getEmail(){
    return email;
  }

  String getNombre(){
    return nombreCompleto;
  }

  String getPassword(){
    return pass;
  }

  String getPhone(){
    return phone;
  }

  String getDni(){
    return dni;
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