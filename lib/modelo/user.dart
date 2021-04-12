import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Usuario {
  String email;
  //String name;
  String password;
  String phone;
  String dni;
  String nombreCompleto;

  Usuario(String email, String password, String phone, String dni, String nombreCompleto){
    this.email = email;
    this.nombreCompleto = nombreCompleto;
    //this.name,
    this.phone = phone;
    this.dni = dni;
    this.password = password;
  }

  String getEmail(){
    return email;
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