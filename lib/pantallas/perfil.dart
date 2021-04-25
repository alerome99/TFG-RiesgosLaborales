import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tfg/notifiers/user_notifier.dart';
import 'package:tfg/pantallas/mofidPerfil.dart';
import 'package:tfg/widgets/menu.dart';
import 'package:path/path.dart' as Path;

import '../customClipper.dart';

class Perfil extends StatefulWidget {
  //final User user;

  /*
  const Perfil({Key key, this.user}) : super(key: key);
  */
  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  PickedFile _imageFile;
  String imagePath;
  final ImagePicker _picker = ImagePicker();
  bool showPassword = false;
  
  @override
  Widget build(BuildContext context) {
    final cajaAzul2 = Container(
        height: 220.0,
        width: 500.0,
        decoration: BoxDecoration(
          gradient:
              LinearGradient(colors: [Colors.cyanAccent, Colors.blueAccent]),
        ),
    );
    UserNotifier userNotifier = Provider.of<UserNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        /*
        actions: <Widget>[
          // action button
          FlatButton(
            onPressed: () => signout(authNotifier),
            child: Text(
              "Logout",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ],
        */
      ),
      drawer: Menu(),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            parteSuperior(),
            SizedBox(height: 10.0),
            Text(
              userNotifier.currentUsuario.nombreCompleto,
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Inspector",
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 50.0),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => ModifPerfil()));
              },
              color: Colors.green,
              padding: EdgeInsets.symmetric(horizontal: 50),
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                "MODIFY PROFILE",
                style: TextStyle(
                    fontSize: 14, letterSpacing: 2.2, color: Colors.white),
              ),
            ),
            Container(child: cajaAzul2),
            //IconButton(icon: Icon(Icons.menu), onPressed: null),
          ],
        ),
      ),
    );
  }

  Widget foto() {
    return Container(
      width: 150,
      height: 150,
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
      width: 150,
      height: 150,
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
      imagePath = imageUrl.toString();
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection('usuario');
      collectionReference
          .doc(userNotifier.currentUsuario.getId())
          .update({'url': imageUrl.toString()});
    }
  }

  Widget parteSuperior() {
    UserNotifier userNotifier = Provider.of<UserNotifier>(context);
    return Container(
      height: 300.0,
      child: Stack(
        children: <Widget>[
          Container(),
          ClipPath(
            clipper: MyCustomClipper(),
            child: Container(
              height: 300.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage("https://picsum.photos/200"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, 1),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                userNotifier.currentUsuario.url == null
                    ? foto()
                    : fotoCargada(),
                //Text(userNotifier.currentUsuario.url),
                //SizedBox(height: 10.0),
                //foto(),
              ],
            ),
          ),
        ],
      ),
    );
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
}
