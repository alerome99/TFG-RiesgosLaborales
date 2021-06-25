import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:tfg/notifiers/auth_notifier.dart';
import 'package:tfg/notifiers/usuario_notifier.dart';
import 'package:tfg/widgets/menu.dart';

import '../providers/db.dart';
import '../modelo/user.dart';

class CambiarPass extends StatefulWidget {
  @override
  _CambiarPassState createState() => _CambiarPassState();
}

class _CambiarPassState extends State<CambiarPass> {
  bool showPassword = false;
  String email;
  Usuario usuario;
  String id;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _contraNuevaRepetidaController =
      TextEditingController();
  final TextEditingController _contraNuevaController = TextEditingController();
  final TextEditingController _contraActualController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String validatePassRepetida(value) {
    if (value.isEmpty) {
      return "Necesario";
    } else if (_contraNuevaRepetidaController.text !=
        _contraNuevaController.text) {
      return "Este campo debe coincidir con el anterior";
    }
    return null;
  }

  String validatePass(value) {
    UsuarioNotifier userNotifier =
        Provider.of<UsuarioNotifier>(context, listen: false);
    if (value.isEmpty) {
      return "Necesario";
    } else if (_contraNuevaController.text.length < 6) {
      return "La contraseña debe de tener más de 6 caracteres";
    } else if (_contraNuevaController.text ==
        userNotifier.currentUsuario.password) {
      return "La contraseña nueva debe ser diferente a la anterior";
    }
    return null;
  }

  String validatePassAntigua(value) {
    UsuarioNotifier userNotifier =
        Provider.of<UsuarioNotifier>(context, listen: false);
    if (value.isEmpty) {
      return "Necesario";
    } else if (_contraActualController.text !=
        userNotifier.currentUsuario.password) {
      return "La contraseña introducida no es correcta";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:_scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      drawer: Menu(),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(left: 16, top: 25, right: 16),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Form(
                key: formKey,
                child: ListView(
                  children: [
                    Text(
                      "Cambio de contraseña",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 55,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 45.0),
                      child: TextFormField(
                        key: Key("passActual"),
                        controller: _contraActualController,
                        obscureText: true,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 3),
                          labelText: "Contraseña actual",
                          labelStyle: TextStyle(fontSize: 22.0),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        validator: validatePassAntigua,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 45.0),
                      child: TextFormField(
                        key: Key("passNueva"),
                        controller: _contraNuevaController,
                        obscureText: true,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 3),
                          labelText: "Nueva contraseña",
                          labelStyle: TextStyle(fontSize: 22.0),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        validator: validatePass,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 45.0),
                      child: TextFormField(
                        key: Key("passNuevaRepetida"),
                        controller: _contraNuevaRepetidaController,
                        obscureText: true,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 3),
                          labelText: "Repita la nueva contraseña",
                          labelStyle: TextStyle(fontSize: 22.0),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        validator: validatePassRepetida,
                      ),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 30.0, 0),
                          child: RaisedButton(
                            key: Key('botonCambiarPass'),
                            onPressed: () {
                              actualizarContra();
                            },
                            color: Colors.green,
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              "SAVE",
                              style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 2.2,
                                  color: Colors.white),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void actualizarContra() async {
    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();

    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    UsuarioNotifier userNotifier =
        Provider.of<UsuarioNotifier>(context, listen: false);
    Usuario u = userNotifier.currentUsuario;
    id = userNotifier.currentUsuario.id;
    try {
      u.password = _contraNuevaController.text;
      await modificarPass(u, id, authNotifier, userNotifier);
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("La contraseña ha sido cambiada con existo"),
      ));
    } catch (e) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Error al cambiar la contraseña"),
      ));
    }
  }
}
