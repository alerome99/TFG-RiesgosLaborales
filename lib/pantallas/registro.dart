import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tfg/notifiers/auth_notifier.dart';
import 'package:tfg/pantallas/login.dart';

import '../providers/db.dart';
import '../modelo/user.dart';

class Registro extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Registro> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordRepetidaController =
      TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();

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
          decoration: boxDecoraccionCustom(),
          height: 60.0,
          child: TextFormField(
            key: Key('registerEmail'),
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 3.0, left: 20.0),
              hintText: 'Introduce un email',
            ),
          ),
        ),
      ],
    );
  }

  Widget botonRegistro() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        key: Key('registerButton'),
          onPressed: () async => registrarCuenta(),
          elevation: 5.0,
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          color: Colors.white,
          child: Text('REGISTRO',
              style: TextStyle(
                color: Color(0xFF526AAA),
                letterSpacing: 1.8,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                fontFamily: 'Open',
              ))),
    );
  }

  Widget inicioSesion() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Text(
        'Tienes una cuenta? ',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18.0,
          fontWeight: FontWeight.w400,
        ),
      ),
      InkWell(
        key: Key('goLogin'),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => Login()));
          },
          child: Text('Inicia Sesión',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              )))
    ]);
  }

  Widget pass() {
    return Column(
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
            key: Key('registerPass'),
            controller: _passwordController,
            obscureText: true,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 3.0, left: 20.0),
              hintText: 'Introduce una contraseña',
            ),
          ),
        ),
      ],
    );
  }

  Widget passRepetida() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Confirma la contraseña',
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
            key: Key('registerPassRepeat'),
            controller: _passwordRepetidaController,
            obscureText: true,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 3.0, left: 20.0),
              hintText: 'Repite la contraseña',
            ),
          ),
        ),
      ],
    );
  }

  Widget telefono() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Número de telefono',
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
            key: Key('registerPhone'),
            controller: _telefonoController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 3.0, left: 20.0),
              hintText: 'Introduce un número de telefono',
            ),
          ),
        ),
      ],
    );
  }

  Widget dni() {
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
          decoration: boxDecoraccionCustom(),
          height: 60.0,
          child: TextFormField(
            key: Key('registerDni'),
            controller: _dniController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 3.0, left: 20.0),
              hintText: 'Introduce un DNI/NIF',
            ),
          ),
        ),
      ],
    );
  }

  Widget nombre() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Nombre completo',
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
            key: Key('registerName'),
            controller: _nombreController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 3.0, left: 20.0),
              hintText: 'Introduce tu nombre completo',
            ),
          ),
        ),
      ],
    );
  }

  Widget direccion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Dirección',
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
            key: Key('registerDireccion'),
            controller: _direccionController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 3.0, left: 20.0),
              hintText: 'Introduce tu direccion',
            ),
          ),
        ),
      ],
    );
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
                    horizontal: 20.0,
                    vertical: 120.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Registrate',
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
                      SizedBox(height: 20.0),
                      passRepetida(),
                      SizedBox(height: 20.0),
                      telefono(),
                      SizedBox(height: 20.0),
                      dni(),
                      SizedBox(height: 20.0),
                      nombre(),
                      SizedBox(height: 20.0),
                      direccion(),
                      SizedBox(height: 25.0),
                      botonRegistro(),
                      SizedBox(height: 10.0),
                      inicioSesion(),
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

  void registrarCuenta() async {
    if (_emailController.text == "" ||
        _passwordController.text == "" ||
        _passwordRepetidaController.text == "" ||
        _telefonoController.text == "" ||
        _dniController.text == "" ||
        _nombreController.text == "") {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Debes rellenar todos los campos"),
      ));
    } else {
      if (_passwordController.text == _passwordRepetidaController.text) {
        Usuario u = new Usuario(
            _emailController.text,
            _passwordController.text,
            _telefonoController.text,
            _dniController.text,
            _nombreController.text,
            "",
            "inspector",
            _direccionController.text);
        AuthNotifier authNotifier =
            Provider.of<AuthNotifier>(context, listen: false);
        try {
          await registrarUsuario(u, authNotifier);
          Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) => Login()));
        } catch (e) {
          _scaffoldKey.currentState.showSnackBar(
              SnackBar(content: Text("Ese email ya está registrado")));
        }
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
              "Los campos de contraseña y contraseña repetida deben de ser iguales"),
        ));
      }
    }
  }
}
