import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'user.dart';

enum AuthStatus{
  Unizitialized,
  Authenticated,
  Authenticating,
  Unauthenticated,
}

class Db with ChangeNotifier  {

    //final FirebaseAuth _auth;//= FirebaseAuth.instance;
    GoogleSignInAccount _googleUser;
    Usuario _user = new Usuario();

    final FirebaseFirestore _db = FirebaseFirestore.instance;
    AuthStatus _status = AuthStatus.Unizitialized;

    final GoogleSignIn _googleSignIn = GoogleSignIn();


  /*
    Db (){
      Firebase.initializeApp();
      mAuth = FirebaseAuth.instance;
      db = FirebaseFirestore.instance;
    }*/

    void iniciarSesion(String e, String p){
      //_auth.signInWithEmailAndPassword(email: e, password: p);
    }
     /*
    String getEmailCurrentUser(){
      return _auth.currentUser.email;
    }*/
}