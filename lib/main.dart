import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
   runApp(MaterialApp(home: MyApp()));
}


class MyApp extends StatelessWidget {


  // This widget is the root of your application.
  
  

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      home: MyHomePage(title: 'Flutter Demo Home Page'),

      /*
      home: Scaffold(
        appBar: AppBar(title: Text('Tareas Firebase')),
        //LECTURA -> MUESTRA UNA LISTA CON TODAS LAS TAREAS Y SI ESTAN CUMPLIDAS O NO
        body: StreamBuilder(
          //AQUI SE HACE LA CONSULTA -> A TODAS LAS INSTANCIAS DE LA COLECCION TAREAS
          stream: FirebaseFirestore.instance.collection('tareas').snapshots(),
          builder: (context, snapshot){
            if(!snapshot.hasData) {
              return Center(child: CircularProgressIndicator(),);
            }
            //SE GUARDA EN UNA LISTA TODOS LOS DATOS DE LA CONSULTA
            //NO ES NECESARIOA HACERLO PERO ES MAS CLARO QUE ESTAR PONIENDO snapshot.data.docs[x]['done'] 
            List<DocumentSnapshot> docs = snapshot.data.docs;
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Checkbox(value: docs[index]['done']), //SE EXTRAEN LOS DATOS DE CADA CAMPO DONE DE CADA INSTANCIA
                  title: Text(docs[index]['what']), //SE EXTRAEN LOS DATOS DE CADA CAMPO WHAT DE CADA INSTANCIA
                );
              }
            );
          }
        ) 
      ),*/
    );
  }
  /*
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('tareas');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc('Ib6d7yZOY4jWpkn6s4OM').get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          return Text("Full Name: ${data['what']}");
        }

        return Text("loading");
      },
    );
  }*/
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String p = "wey";

  void _incrementCounter() {
    Map<String, dynamic> demoData = { "name" : p,
    "moto" : "Let's learn and grow together"};
    //AÑADE A LA COLECCION data UNA NUEVA INSTANCIA CON DOS DATOS UNO name Y OTRO moto CUYOS VALORES ESTAN DEFINIDOS ENCIMA
    //ESTO SE PODRIA METER EN UNA FUNCION PARA EL LOGIN POR EJEMPLO
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('data');
    collectionReference.add(demoData);
    setState(() {
      _counter++;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

