import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tfg/widgets/menu.dart';

import '../custromClipper.dart';

class MainPage extends StatefulWidget {
  final User user;

  const MainPage({Key key, this.user}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  FirebaseAuth _auth = FirebaseAuth.instance;

  Widget parteSuperior() {
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
                Container(
                  width: 110,
                  height: 110,
                  child: Stack(
                    fit: StackFit.expand,
                    overflow: Overflow.visible,
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/images/usuario.png'),
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
                                borderRadius: BorderRadius.circular(50),),
                            color: Color(0xFFF5F6F9),
                            onPressed: () {},
                            child: Image.asset('assets/images/camara.png',
                            width: 60,
                            height: 60,),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                /*
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 4,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 2,
                        blurRadius: 10,
                        color: Colors.white,
                      ),
                    ],
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/12/User_icon_2.svg/1200px-User_icon_2.svg.png'),
                    ),
                  ),
                ),*/

                /*
                      Positioned(
                          child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/1/12/User_icon_2.svg/1200px-User_icon_2.svg.png'),
                      )),*/
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
    return Scaffold(
      drawer: Menu(),
      body: Stack(
        children: <Widget>[
          //IconButton(icon: Icon(Icons.menu), onPressed: null),
          Container(
            child: parteSuperior(),
          ),
        ],
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
