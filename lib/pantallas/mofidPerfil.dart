import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tfg/notifier/user_notifier.dart';
import 'package:tfg/pantallas/perfil.dart';
import 'package:path/path.dart' as Path;

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
  Usuario usuario;
  PickedFile _imageFile;
  String id;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  Widget foto() {
    return Container(
      width: 110,
      height: 110,
      child: Stack(
        fit: StackFit.expand,
        overflow: Overflow.visible,
        children: [
          //Image.network("https://firebasestorage.googleapis.com/v0/b/tfg-riesgos-laborales-f85a8.appspot.com/o/2b9e864c-ada2-4520-ba5f-19d39faffa9b5915008143652343343.jpg?alt=media&token=6675f928-b98a-459a-ae51-4ed06dca09c0"),
          //Image.networs"https://firebasestorage.googleapis.com/v0/b/tfg-riesgos-laborales-f85a8.appspot.com/o/2b9e864c-ada2-4520-ba5f-19d39faffa9b5915008143652343343.jpg?alt=media&token=6675f928-b98a-459a-ae51-4ed06dca09c0"
          CircleAvatar(
            //backgroundImage: NetworkImage("https://firebasestorage.googleapis.com/v0/b/tfg-riesgos-laborales-f85a8.appspot.com/o/2b9e864c-ada2-4520-ba5f-19d39faffa9b5915008143652343343.jpg?alt=media&token=6675f928-b98a-459a-ae51-4ed06dca09c0"),
            backgroundImage: _imageFile == null
                ? AssetImage('assets/images/usuario.png')
                : FileImage(File(_imageFile.path)),
            //:NetworkImage(imagePath),
          ),
          Positioned(
            right: -6,
            bottom: 0,
            child: SizedBox(
              height: 40,
              width: 40,
              child: FlatButton(
                padding: EdgeInsets.all(8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                color: Color(0xFFF5F6F9),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: ((builder) => imageModal()),
                  );
                },
                child: Image.asset(
                  'assets/images/camara.png',
                  width: 60,
                  height: 60,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget fotoCargada() {
    UserNotifier userNotifier =
        Provider.of<UserNotifier>(context, listen: false);
    return Container(
      width: 110,
      height: 110,
      child: Stack(
        fit: StackFit.expand,
        overflow: Overflow.visible,
        children: [
          //Image.network("https://firebasestorage.googleapis.com/v0/b/tfg-riesgos-laborales-f85a8.appspot.com/o/2b9e864c-ada2-4520-ba5f-19d39faffa9b5915008143652343343.jpg?alt=media&token=6675f928-b98a-459a-ae51-4ed06dca09c0"),
          //Image.networs"https://firebasestorage.googleapis.com/v0/b/tfg-riesgos-laborales-f85a8.appspot.com/o/2b9e864c-ada2-4520-ba5f-19d39faffa9b5915008143652343343.jpg?alt=media&token=6675f928-b98a-459a-ae51-4ed06dca09c0"
          CircleAvatar(
            //backgroundImage: NetworkImage("https://firebasestorage.googleapis.com/v0/b/tfg-riesgos-laborales-f85a8.appspot.com/o/2b9e864c-ada2-4520-ba5f-19d39faffa9b5915008143652343343.jpg?alt=media&token=6675f928-b98a-459a-ae51-4ed06dca09c0"),
            backgroundImage: _imageFile == null
                ? NetworkImage(userNotifier.currentUsuario.url)
                : FileImage(File(_imageFile.path)),
            //:NetworkImage(imagePath),
          ),
          Positioned(
            right: -6,
            bottom: 0,
            child: SizedBox(
              height: 40,
              width: 40,
              child: FlatButton(
                padding: EdgeInsets.all(8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                color: Color(0xFFF5F6F9),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: ((builder) => imageModal()),
                  );
                },
                child: Image.asset(
                  'assets/images/camara.png',
                  width: 60,
                  height: 60,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void actualizarDatos() async {
    UserNotifier userNotifier =
        Provider.of<UserNotifier>(context, listen: false);
    id = userNotifier.currentUsuario.getId();
    if (_emailController.text == "") {
      _emailController.text = userNotifier.currentUsuario.email;
    }
    if (_numeroController.text == "") {
      _numeroController.text = userNotifier.currentUsuario.phone;
    }
    if (_nombreController.text == "") {
      _nombreController.text = userNotifier.currentUsuario.nombreCompleto;
    }
    await modificarUsuario(_emailController.text, _numeroController.text,
        _nombreController.text, id);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) => Perfil()));

    /*
      CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('usuario');
  collectionReference
      .doc(userNotifier.currentUsuario.getId())
      .update({'email': _emailController.toString(), 'numero': _numeroController.toString(), 'nombre': _nombreController.toString()});
      */
  }

  void takePhoto(ImageSource source) async {
    UserNotifier userNotifier =
        Provider.of<UserNotifier>(context, listen: false);
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      _imageFile = pickedFile;
    });
    if (pickedFile != null) {
      String fileName = Path.basename(_imageFile.path);
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child(fileName);
      var imageFile = File(_imageFile.path);
      UploadTask uploadTask = ref.putFile(imageFile);
      var imageUrl = await (await uploadTask).ref.getDownloadURL();
      uploadTask.then((res) {});
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection('usuario');
      collectionReference
          .doc(userNotifier.currentUsuario.getId())
          .update({'url': imageUrl.toString()});
    }
  }

  Widget imageModal() {
    return Container(
        height: 100.0,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          children: <Widget>[
            Text(
              "Choose Profile photo",
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton.icon(
                    onPressed: () {
                      takePhoto(ImageSource.camera);
                    },
                    icon: Icon(Icons.camera),
                    label: Text("Camera")),
                FlatButton.icon(
                    onPressed: () {
                      takePhoto(ImageSource.gallery);
                    },
                    icon: Icon(Icons.image),
                    label: Text("Gallery"))
              ],
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    UserNotifier userNotifier = Provider.of<UserNotifier>(context);
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
                  Align(
                    alignment: Alignment(0, 1),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        userNotifier.currentUsuario.url == null
                            ? foto()
                            : fotoCargada(),
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
                          hintText:
                              userNotifier.currentUsuario.nombreCompleto == null
                                  ? ""
                                  : userNotifier.currentUsuario.nombreCompleto,
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
                          hintText: userNotifier.currentUsuario.email == null
                              ? ""
                              : userNotifier.currentUsuario.email,
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
                          hintText: userNotifier.currentUsuario.phone == null
                              ? ""
                              : userNotifier.currentUsuario.phone,
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
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => Perfil()));
                        },
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
