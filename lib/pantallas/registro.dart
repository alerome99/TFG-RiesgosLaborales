import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Registro extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Registro> {
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
          child: TextField(
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
          onPressed: () => print('ir a registro'),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
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
          child: Text(
            'Sign In',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            )
          )
        )
      ]
    );
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
          child: TextField(
            obscureText: true,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter your Password',
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
}
