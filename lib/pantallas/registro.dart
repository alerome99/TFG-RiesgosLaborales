import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../db.dart';
import '../user.dart';
import 'principal.dart';

class Registro extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Registro> {
  //String _prueba; -> Funciona
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordRepeatController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  BoxDecoration myBoxDecoration() {
    //Color(0xFF9999D9),
    //Color(0xA992A5F9),
    //Color(0xFf73aef5),
    //Color(0xFF42A5F9),
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
    return Column(
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
              contentPadding: EdgeInsets.only(top: 3.0, left: 20.0),
              //prefixIcon: Icon(
              //Icons.email,
              //color: Colors.white,
              //),
              hintText: 'Enter your Email',
            ),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget buildButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
          onPressed: () async => _registerAccount(),
          elevation: 5.0,
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          color: Colors.white,
          child: Text('REGISTER',
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
        'Already have an Account? ',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18.0,
          fontWeight: FontWeight.w400,
        ),
      ),
      InkWell(
          onTap: () {
            Navigator.of(context).pushNamed("login");
          },
          child: Text('Sign In',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              )))
    ]);
  }

  Widget buildPass() {
    return Column(
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
            controller: _passwordController,
            obscureText: true,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 3.0, left: 20.0),
              //prefixIcon: Icon(
                //Icons.lock,
                //color: Colors.white,
              //),
              hintText: 'Enter your Password',
            ),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget buildPassRepeat() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Confirm Password',
          //prueba, -> Funciona
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
            controller: _passwordRepeatController,
            obscureText: true,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 3.0, left: 20.0),
              //prefixIcon: Icon(
              //Icons.lock,
              //color: Colors.white,
              //),
              hintText: 'Repeat your Password',
              //hintStyle:
            ),
          ),
        ),
      ],
    );
  }

    Widget buildTlefono() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Phone number',
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
            controller: _phoneController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 3.0, left: 20.0),
              //prefixIcon: Icon(
              //Icons.email,
              //color: Colors.white,
              //),
              hintText: 'Enter your phone number',
            ),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget buildDni() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'DNI/NIF',
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
            controller: _dniController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 3.0, left: 20.0),
              //prefixIcon: Icon(
              //Icons.email,
              //color: Colors.white,
              //),
              hintText: 'Enter your DNI/NIF',
            ),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget buildName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Full name',
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
            controller: _nameController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 3.0, left: 20.0),
              //prefixIcon: Icon(
              //Icons.email,
              //color: Colors.white,
              //),
              hintText: 'Enter your full name',
            ),
            validator: (String value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    //_prueba = "hola"; -> Funciona
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
                      //Color(0xFF9999D9),
                      Color(0xF992A5F9),
                      //Color(0xFF42A5F9),
                      //Color(0xFf73aef5),
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
                        'Sign Up',
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
                      SizedBox(height: 20.0),
                      buildPassRepeat(),
                      SizedBox(height: 20.0),
                      buildTlefono(),
                      SizedBox(height: 20.0),
                      buildDni(),
                      SizedBox(height: 20.0),
                      buildName(),
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

  void _registerAccount() async {
    if(_emailController.text=="" || _passwordController.text==""  || _passwordRepeatController.text=="" || _phoneController.text=="" || _dniController.text=="" || _nameController.text==""){
        _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("You must fill all the fields"),
      ));
      } else {
        if (_passwordController.text == _passwordRepeatController.text){
      Usuario u = new Usuario(_emailController.text, _passwordController.text, _phoneController.text, _dniController.text, _nameController.text);
      Db database = new Db(); 
      await database.registrarUsuario(u);
      User user = database.getCurrentUser();
      if (user != null) {
        /*
        if (!user.emailVerified) {
          await user.sendEmailVerification();
        }*/
        //await user.updateProfile();
        //final user1 = _auth.currentUser;
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => MainPage(
                  user: user,
                  //user: user1,
                )));
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Password and repeat password must have the same content"),
      ));
    }
      }  
}
}
