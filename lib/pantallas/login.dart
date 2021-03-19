import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../db.dart';
import '../user.dart';
import 'principal.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  //final Db database = new Db();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Color(0xFF42A5F9).withOpacity(0.7),
          spreadRadius: 1,
          blurRadius: 1,
          offset: Offset(0, 3),
        ),
      ],
      color: Color(0xFF9999D9),
      border: Border.all(
        width: 2.0,
        color: Color(0x000000000),
      ),
      borderRadius: BorderRadius.all(Radius.circular(15.0)),
    );
  }

  Widget buildEmail() {
    return Form(
      key: _formKey1,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Recursive',
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: myBoxDecoration(),
          height: 60.0,
          child: TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Enter your Email',
            ),
            /*
            validator: (value) {
              if (value.isEmpty) return 'Please enter some text';
              return null;
            },*/
          ),
        ),
      ],
    ),
    );
  }

    Widget buildPass() {
    return Form(
      key: _formKey2,
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Recursive',
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: myBoxDecoration(),
          height: 60.0,
          child: TextFormField(
            obscureText: true,
            controller: _passwordController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                
                Icons.lock,
                color: Colors.white,
                //size: 16
              ),/*
              prefixIconConstraints: BoxConstraints(
                minWidth: 50,
                minHeight: 200,
              ),*/
              hintText: 'Enter your Password',
            ),
            /*
            validator: (value) {
              if (value.isEmpty) return 'Please enter some text';
              return null;
            },*/
          ),
        ),
      ],
      ),
    );
  }

  Widget buildButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
          onPressed: () async {
            if (_formKey1.currentState.validate() && _formKey2.currentState.validate()) {
            _signInWithEmailAndPassword();
            }
          },
          elevation: 5.0,
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          color: Colors.white,
          child: Text('LOGIN',
              style: TextStyle(
                color: Color(0xFF526AAA),
                letterSpacing: 1.8,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                fontFamily: 'Open',
              ))),
    );
  }

  Widget buildSignUp() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Text(
        'Don\'t have an Account? ',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18.0,
          fontWeight: FontWeight.w400,
        ),
      ),
      InkWell(
          onTap: () {
            Navigator.of(context).pushNamed("registro");
          },
          child: Text('Sign Up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              )))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xF992A5F9),
                      Color(0xC142A5F9),
                      Colors.blue,
                    ],
                    stops: [0.2, 0.6, 0.9],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 120.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Recursive',
                          fontSize: 36.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 40.0),
                      buildEmail(),
                      SizedBox(height: 20.0),
                      buildPass(),
                      SizedBox(height: 30.0),
                      buildButton(),
                      SizedBox(height: 100.0),
                      buildSignUp(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signInWithEmailAndPassword() async {
    Usuario u = new Usuario(_emailController.text, _passwordController.text); //RELLENAR
    Db database = new Db();
    try {

      await database.iniciarSesion(u) as User;
          /*
      if (!user.emailVerified) {
        await user.sendEmailVerification();
      }*/
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
        return MainPage(
          user: database.getCurrentUser(),
        );
      }));
    } catch (e) {
      if(_emailController.text=="" || _passwordController.text==""){
        _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("You must fill all the fields"),
      ));
      }else{
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Wrong email or password"),
      ));
      }
      /*
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Wrong email or password"),
      ));*/
    }
  }
}
