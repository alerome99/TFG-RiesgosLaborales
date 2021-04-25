import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfg/notifiers/auth_notifier.dart';
import 'package:tfg/pantallas/login.dart';
import 'package:tfg/pantallas/perfil.dart';
import 'package:tfg/pantallas/principal.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: <Color>[
                Colors.blueAccent,
                Colors.lightBlue,
              ])),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(0.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset(
                          'assets/images/delegado-prevencion-riesgos-laborales.jpg',
                          width: 95,
                          height: 95,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(6.0),
                      child: Text(
                        'Riesgos laborales',
                        style: TextStyle(color: Colors.white, fontSize: 25.0),
                      ),
                    ),
                  ],
                ),
              )),
          CustomList(
              Icons.home,
              'Home',
              () => {
                    irAPaginaPrincipal(),
                  }),
          CustomList(
              Icons.person,
              'Profile',
              () => {
                    irAPerfil(),
                  }),
          CustomList(
              Icons.lock,
              'Log Out',
              () => {
                    signOut(),
                  }),
        ],
      ),
    );
  }

  void irAPerfil() async {
    {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) => Perfil()));
    }
  }

  void signOut() async {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    await FirebaseAuth.instance
        .signOut()
        .catchError((error) => print(error.code));
    authNotifier.setUser(null);
    Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) => Login()));
  }

  void irAPaginaPrincipal() async {
    {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => MainPage()));
    }
  }
}

class CustomList extends StatelessWidget {
  IconData icon;
  String text;
  Function onTap;

  CustomList(this.icon, this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade400))),
        child: InkWell(
          splashColor: Colors.lightBlue,
          onTap: onTap,
          child: Container(
            height: 55,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(icon),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(text,
                          style: TextStyle(
                            fontSize: 18.0,
                          )),
                    ),
                  ],
                ),
                Icon(Icons.arrow_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
