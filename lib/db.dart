import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

    User getCurrentUser(){
      return _auth.currentUser;
    }
     /*
    String getEmailCurrentUser(){
      return _auth.currentUser.email;
    }*/
}