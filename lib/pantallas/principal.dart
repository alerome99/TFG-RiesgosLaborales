import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tfg/modelo/user.dart';
import 'package:tfg/notifier/auth_notifier.dart';
import 'package:tfg/notifier/user_notifier.dart';
import 'package:tfg/widgets/menu.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

import '../customClipper.dart';
import '../db.dart';

class MainPage extends StatefulWidget {
  final User user;

  const MainPage({Key key, this.user}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  PickedFile _imageFile;
  String imagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    UserNotifier userNotifier =
        Provider.of<UserNotifier>(context, listen: false);
    Usuario u = new Usuario("", "", "", "", "", "");
    setUserInic(u, userNotifier);
    //getUser(userNotifier);
    super.initState();
  }

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
      uploadTask.then((res) {
      });
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
                userNotifier.currentUsuario.url == null ?
                foto(): fotoCargada(),
                //Text(userNotifier.currentUsuario.url),
                //SizedBox(height: 10.0),
                //foto(),
                SizedBox(height: 4.0),
                Text(
                  "Cargar nombre usuario",
                  style: TextStyle(
                    fontSize: 21.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Developer",
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    UserNotifier userNotifier = Provider.of<UserNotifier>(context);
    getUser(userNotifier);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
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
      ),
      drawer: Menu(),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            parteSuperior(),
            SizedBox(height: 50.0),
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 15.0, top: 15.0, bottom: 15.0),
                  height: 200,
                  width: 188,
                  child: Card(
                    color: Colors.grey,
                    child: InkWell(
                        onTap: () {},
                        splashColor: Colors.blue,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(Icons.analytics, size: 70.0),
                              Text('Stadistics',
                                  style: new TextStyle(fontSize: 17.0)),
                            ],
                          ),
                        )),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 15.0, top: 15.0, bottom: 15.0),
                  height: 200,
                  width: 188,
                  child: Card(
                    color: Colors.grey,
                    child: InkWell(
                        onTap: () {},
                        splashColor: Colors.blue,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(Icons.add_circle_rounded, size: 70.0),
                              Text('Add Inspection',
                                  style: new TextStyle(fontSize: 17.0)),
                            ],
                          ),
                        )),
                  ),
                ),
              ],
            ),
            //IconButton(icon: Icon(Icons.menu), onPressed: null),
          ],
        ),
      ),
    );
    /*
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Text(
                widget.user.email,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
            Container(
              child: OutlineButton(
                child: Text("LogOut"),
                onPressed: () {
                  _signOut().whenComplete(() {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => Login()));
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );*/
  }

  Future _signOut() async {
    await _auth.signOut();
  }
}
