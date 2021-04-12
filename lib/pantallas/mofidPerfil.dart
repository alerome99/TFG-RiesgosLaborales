import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:tfg/notifier/user_notifier.dart';
import 'package:tfg/pantallas/perfil.dart';

import '../db.dart';
import '../modelo/user.dart';

class ModifPerfil extends StatefulWidget {
  //final User user;

  /*
  const ModifPerfil({Key key, this.user}) : super(key: key);
  */
  @override
  _ModifPerfilState createState() => _ModifPerfilState();
}

class _ModifPerfilState extends State<ModifPerfil> {
  bool showPassword = false;
  //Db database = new Db();
  String email;
  File _imageFile;
  Usuario usuario;
  String id;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  


  @override
  void initState() {
    UserNotifier userNotifier =
        Provider.of<UserNotifier>(context, listen: false);
    Usuario u = new Usuario("", "", "", "", "");
    setUserInic(u, userNotifier);
    super.initState();
  }

  void actualizarDatos() async{
    UserNotifier userNotifier =
        Provider.of<UserNotifier>(context, listen: false);
    id = userNotifier.currentUsuario.getId();
    if(_emailController.text=="" && _numeroController.text=="" && _nombreController.text==""){
      print("holaaaaaaaaaaaaaaaaaaaaaaaa");
    }else{
      //REVISAR ESTO REVISAR ESTO REVISAR ESTO REVISAR ESTO REVISAR ESTO REVISAR ESTO REVISAR ESTO REVISAR ESTO REVISAR ESTO REVISAR ESTO REVISAR ESTO REVISAR ESTO REVISAR ESTO REVISAR ESTO
      //AL GUARDAR SE GUARDA EN FIRESTORE PERO NO RECARGA BIEN LA PAGINA (POSIBLE SOLUCIONAR REDIRECCIONAR A LA PAGINA DE PERFIL)
      if(_emailController.text=="" && _numeroController.text==""){
        await modificarUsuario(userNotifier.currentUsuario.email, userNotifier.currentUsuario.phone, _nombreController.text, id);
      }
      if(_emailController.text==""){
        await modificarUsuario(userNotifier.currentUsuario.email, _numeroController.text, _nombreController.text, id);
      }
      if(_emailController.text=="" && _nombreController.text==""){
        await modificarUsuario(userNotifier.currentUsuario.email, _numeroController.text, userNotifier.currentUsuario.nombreCompleto, id);
      }
      if(_numeroController.text=="" && _nombreController.text==""){
        await modificarUsuario(_emailController.text, userNotifier.currentUsuario.phone, userNotifier.currentUsuario.nombreCompleto, id);
      }
      if(_numeroController.text==""){
        await modificarUsuario(_emailController.text, userNotifier.currentUsuario.phone, _nombreController.text, id);
      }
      if(_nombreController.text==""){
        await modificarUsuario(_emailController.text, _numeroController.text, userNotifier.currentUsuario.nombreCompleto, id);
      }
    }
    Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => Perfil()));
    
    /*
      CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('usuario');
  collectionReference
      .doc(userNotifier.currentUsuario.getId())
      .update({'email': _emailController.toString(), 'numero': _numeroController.toString(), 'nombre': _nombreController.toString()});
      */
  }

  @override
  Widget build(BuildContext context) {
    UserNotifier userNotifier = Provider.of<UserNotifier>(context);

    getUser(userNotifier);
    //cargarUsuario();
    //print(usuario.getPhone());
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
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.green,
            ),
            onPressed: () {},
          ),
        ],
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
                    "Edit Profile",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 4,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    color: Colors.black.withOpacity(0.1),
                                    offset: Offset(0, 10))
                              ],
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    "https://images.pexels.com/photos/3307758/pexels-photo-3307758.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=250",
                                  ))),
                        ),
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 4,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                                color: Colors.green,
                              ),
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 35.0),
                    child: TextFormField(
                      controller: _nombreController,
                      obscureText: false,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 3),
                          labelText: "Nombre Completo",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: userNotifier.currentUsuario.nombreCompleto,
                          hintStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          )),
                    ),
                  ),
                  //buildTextField("Nombre Completo", userNotifier.currentUsuario.nombreCompleto !=null ? userNotifier.currentUsuario.nombreCompleto : "", false),
                  //buildTextField(
                      //"Email", FirebaseAuth.instance.currentUser.email, false),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 35.0),
                    child: TextFormField(
                      controller: _emailController,
                      obscureText: false,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 3),
                          labelText: "Email",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: userNotifier.currentUsuario.email,
                          hintStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          )),
                    ),
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
                          hintText: userNotifier.currentUsuario.phone,
                          hintStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlineButton(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        onPressed: () {},
                        child: Text("CANCEL",
                            style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 2.2,
                                color: Colors.black)),
                      ),
                      RaisedButton(
                        onPressed: () {
                          actualizarDatos();
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
                      )
                    ],
                  )
                ],
              ),
            ),
          ),

          /*
          Scaffold(
              body: StreamBuilder(
                // <2> Pass `Future<QuerySnapshot>` to future
                stream: FirebaseFirestore.instance
                    .collection('usuario')
                    .where('email', isEqualTo: email)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final List<DocumentSnapshot> documents = snapshot.data.docs;

                    return Stack(
                      children: <Widget>[
                        buildTextField("Nombre Completo", email, false),
                        /*
                              buildTextField("Nombre Completo", documents[0]['nombre'], false),
                              buildTextField("Email", documents[0]['email'], false),
                              buildTextField("Telefono", documents[0]['numero'], false),
                              buildTextField("Location", "TLV, Israel", false),
                              */
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text("It Error!");
                  }
                },
              ),
            /*StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('usuario')
                      .where('email', isEqualTo: email)
                    .snapshots(),
                ),*/
          ),*/
        ],
      ),
    );
  }

  Widget _buildList(QuerySnapshot snapshot) {
    return ListView.builder(
        itemCount: snapshot.docs.length,
        itemBuilder: (context, index) {
          final doc = snapshot.docs[index];

          return ListTile(title: Text("hahaha"));
        });
  }

  Widget buildTextField(
      String labelText, String placeholder, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Colors.grey,
                    ),
                  )
                : null,
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
    );
  }
  


/*
  Future<void> cargarUsuario() async {
    /*
        email = database.getCurrentUser().email;
        Usuario usuario =  database.getUsuarioPorEmail(email) as Usuario;
        //type 'Future<Usuario>' is not a subtype of type 'Usuario' in type cast
        //Usuario u = usuario.
        String prueba = usuario.getNombre();
        print("holaaaaaaaaaaa $email");
        print("holaaaaaaa2 $prueba");
        */
    //email = database.getCurrentUser().email;
    Usuario usuario;
    FirebaseFirestore.instance
        .collection('usuario')
        .where('email', isEqualTo: email)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc['dni']);
        usuario = new Usuario(
            doc['email'], null, doc['numero'], doc['dni'], doc['nombre']);
      });
    });
  }*/
}
