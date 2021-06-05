import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:tfg/notifiers/auth_notifier.dart';
import 'package:tfg/notifiers/usuario_notifier.dart';
import 'package:tfg/pantallas/perfil.dart';
import 'package:tfg/widgets/foto.dart';
import 'package:tfg/widgets/fotoCargada.dart';

import '../providers/db.dart';
import '../modelo/user.dart';

class ModifPerfil extends StatefulWidget {
  @override
  _ModifPerfilState createState() => _ModifPerfilState();
}

class _ModifPerfilState extends State<ModifPerfil> {
  bool showPassword = false;
  String email;
  Usuario usuario;
  String id;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();

  @override
  void initState() {
    super.initState();
    UsuarioNotifier userNotifier =
        Provider.of<UsuarioNotifier>(context, listen: false);

    if (userNotifier.currentUsuario != null) {
      _nombreController.text = userNotifier.currentUsuario.nombreCompleto;
      _numeroController.text = userNotifier.currentUsuario.telefono;
      _emailController.text = userNotifier.currentUsuario.email;
    }
  }

  void actualizarDatos() async {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    UsuarioNotifier userNotifier =
        Provider.of<UsuarioNotifier>(context, listen: false);
    Usuario u = userNotifier.currentUsuario;
    id = userNotifier.currentUsuario.getId();
    if (_emailController.text == "") {
      _emailController.text = userNotifier.currentUsuario.email;
    }
    if (_numeroController.text == "") {
      _numeroController.text = userNotifier.currentUsuario.telefono;
    }
    u.setEmail(_emailController.text);
    u.setNumero(_numeroController.text);
    await modificarUsuario(u, id, authNotifier, userNotifier);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) => Perfil()));
  }

  @override
  Widget build(BuildContext context) {
    UsuarioNotifier userNotifier = Provider.of<UsuarioNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.green,
          ),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) => Perfil()));
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(left: 16, top: 25, right: 16),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: ListView(
                children: [
                  Text(
                    "Editar Perfil",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  Align(
                    alignment: Alignment(0, 1),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        userNotifier.currentUsuario.url == null
                            ? Foto()
                            : FotoCargada(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 45,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 35.0),
                    child: TextFormField(
                      controller: _numeroController,
                      obscureText: false,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 3),
                        labelText: "Telefono",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 35.0),
                    child: TextFormField(
                      controller: _emailController,
                      obscureText: false,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 3),
                        labelText: "Email",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlineButton(
                        padding: EdgeInsets.symmetric(horizontal: 47),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => Perfil()));
                        },
                        child: Text("CANCELAR",
                            style: TextStyle(
                                fontSize: 13,
                                letterSpacing: 2.2,
                                color: Colors.black)),
                      ),
                      RaisedButton(
                        onPressed: () {
                          actualizarDatos();
                        },
                        color: Colors.green,
                        padding: EdgeInsets.symmetric(horizontal: 47),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          "GUARDAR",
                          style: TextStyle(
                              fontSize: 13,
                              letterSpacing: 2.2,
                              color: Colors.white),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
