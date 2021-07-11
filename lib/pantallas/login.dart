import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tfg/notifiers/auth_notifier.dart';
import 'package:tfg/notifiers/usuario_notifier.dart';
import 'package:tfg/pantallas/principal.dart';
import 'package:tfg/pantallas/registro.dart';

import '../providers/db.dart';
import '../modelo/user.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

enum AuthFormType { signIn, signUp, reset }

class _LoginState extends State<Login> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _emailRecController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    initializeCurrentUser(authNotifier);
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  BoxDecoration boxDecoraccionCustom() {
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

  Widget email() {
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
            decoration: boxDecoraccionCustom(),
            height: 60.0,
            child: TextFormField(
              key: Key("emailField"),
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
                hintText: 'Introduce tu email',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget pass() {
    return Form(
      key: _formKey2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Contraseña',
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
            decoration: boxDecoraccionCustom(),
            height: 60.0,
            child: TextFormField(
              key: Key("passField"),
              obscureText: true,
              controller: _passwordController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
                hintText: 'Introduce tu contraseña',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget botonInicioSesion() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
          key: Key('loginButton'),
          onPressed: () async {
            if (_formKey1.currentState.validate() &&
                _formKey2.currentState.validate()) {
              iniciarSesionPassEmail();
            }
          },
          elevation: 5.0,
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          color: Colors.white,
          child: Text('INICIO SESION',
              style: TextStyle(
                color: Color(0xFF526AAA),
                letterSpacing: 1.8,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                fontFamily: 'Open',
              ))),
    );
  }

  Widget irARegistro() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Text(
        '¿No tienes una cuenta aún? ',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18.0,
          fontWeight: FontWeight.w400,
        ),
      ),
      InkWell(
          key: Key('goRegister'),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => Registro()));
          },
          child: Text('Registrate',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
              )))
    ]);
  }

  Widget recuperacionPass() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Text(
        '¿Has olvidado tu contraseña? ',
        style: TextStyle(
          color: Colors.white,
          fontSize: 17.0,
          fontWeight: FontWeight.w400,
        ),
      ),
      InkWell(
          onTap: () {
            recuperarPassModal();
          },
          child: Text('Recuperar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              )))
    ]);
  }

  Widget recuperarPassModal() {
    final size = MediaQuery.of(context).size;
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 35.0),
              child: Container(
                width: size.width * 0.80,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 3.0,
                          offset: Offset(0.0, 5.0),
                          spreadRadius: 3.0)
                    ]),
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        gradient: LinearGradient(
                            colors: [Colors.lightGreen, Colors.greenAccent]),
                      ),
                      alignment: Alignment.center,
                      height: size.height * 0.1,
                      width: double.infinity,
                      child: Text(
                        'Recupera tu contraseña',
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 20.0,
                            color: Colors.white),
                      ),
                    ),
                    Material(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(14.0, 14.0, 28.0, 14.0),
                        child: Form(
                          child: Column(
                            children: <Widget>[
                              _crearCampoEmail(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(
                          child: Text('Cancelar'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        FlatButton(
                          child: Text('Enviar'),
                          onPressed: () {
                            resetearPass();
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ));
        });
  }

  Widget modalBaja(String motivo) {
    final size = MediaQuery.of(context).size;
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 35.0),
              child: Container(
                width: size.width * 0.80,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 3.0,
                          offset: Offset(0.0, 5.0),
                          spreadRadius: 3.0)
                    ]),
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        gradient: LinearGradient(
                            colors: [Colors.lightGreen, Colors.greenAccent]),
                      ),
                      alignment: Alignment.center,
                      height: size.height * 0.1,
                      width: double.infinity,
                      child: Text(
                        'Usuario dado de baja',
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 20.0,
                            color: Colors.white),
                      ),
                    ),
                    Material(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(14.0, 14.0, 28.0, 14.0),
                        child: Text(
                          motivo,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(
                          child: Text('Aceptar'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        FlatButton(
                          child: Text('Salir'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    )
                  ],
                ),
              ));
        });
  }

  @override
  Widget _crearCampoEmail() {
    return TextFormField(
      controller: _emailRecController,
      textCapitalization: TextCapitalization.words,
      validator: (value) {
        if (value.length < 1) {
          return 'Ingrese su email';
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
          labelText: 'Email', labelStyle: TextStyle(fontSize: 20.0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
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
                    horizontal: 20.0,
                    vertical: 120.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Inicio Sesión',
                        key: Key('textDeLogin'),
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Recursive',
                          fontSize: 36.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 40.0),
                      email(),
                      SizedBox(height: 20.0),
                      pass(),
                      SizedBox(height: 30.0),
                      botonInicioSesion(),
                      SizedBox(height: 60.0),
                      irARegistro(),
                      SizedBox(height: 10.0),
                      recuperacionPass(),
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

  void iniciarSesionPassEmail() async {
    FocusScope.of(context).requestFocus(new FocusNode());
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    UsuarioNotifier userNotifier =
        Provider.of<UsuarioNotifier>(context, listen: false);
    Usuario u = Usuario(_emailController.text, _passwordController.text, null,
        null, null, null, null, null);
    try {
      await login(u, authNotifier);
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('usuario')
          .where('email', isEqualTo: u.email)
          .get();
      Usuario userT;
      snapshot.docs.forEach((document) {
        Usuario user = Usuario.fromMap(document.data());
        userT = user;
      });
      if (userT.baja) {
        modalBaja(userT.motivo);
      } else {
        await getUser(userNotifier);
        Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => MainPage()));
      }
    } catch (e) {
      if (_emailController.text == "" || _passwordController.text == "") {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Debes rellenar todos los campos"),
        ));
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("Contraseña o email incorrectos"),
        ));
      }
    }
  }

  void resetearPass() async {
    await resetearContra(_emailRecController.text);
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Se ha enviado el mensaje a tu correo"),
    ));
  }
}
