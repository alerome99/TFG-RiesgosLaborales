import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  const Menu({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
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
                      /*
                    CircleAvatar(
                        //borderRadius: BorderRadius.all(Radius.circular(100.0)),
                        radius : 60, 
                        child: Padding(padding: EdgeInsets.all(10.0),
                        child: Image.asset(
                          'assets/images/delegado-prevencion-riesgos-laborales.jpg',
                          width: 100,
                          height: 100,
                        ),
                      ),
                      ),*/
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
                      Padding(padding: EdgeInsets.all(6.0), child: Text('Riesgos laborales', style: TextStyle(color: Colors.white, fontSize: 25.0),),),
                    ],
                  ),
                )),
            CustomList(Icons.person, 'Profile', () => {}),
            CustomList(Icons.add_circle_rounded, 'Add Inspection', () => {}), 
            CustomList(Icons.analytics, 'Past Inpections', () => {}),
            CustomList(Icons.lock, 'Log Out', () => {}),
          ],
        ),
    );
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
