import 'package:firebase_core/firebase_core.dart';
import 'db.dart';
import 'add.dart';
import 'view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Database db;
  List docs = [];
  initialise() {
    db = Database();
    db.initiliase();
    db.read().then((value) => {
          setState(() {
            docs = value;
          })
        });
  }

  @override
  void initState() {
    super.initState();
    initialise();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(56, 75, 49, 1.0),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(56, 75, 49, 1.0),
        title: Text("Acciones de guerra"),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                  'https://w0.peakpx.com/wallpaper/540/152/HD-wallpaper-camouflage-pattern-green-black.jpg'),
              fit: BoxFit.cover),
        ),
        child: ListView.builder(
          itemCount: docs.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              margin: EdgeInsets.all(10),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  View(accion: docs[index], db: db)))
                      .then((value) => {
                            if (value != null) {initialise()}
                          });
                },
                contentPadding: EdgeInsets.only(right: 30, left: 36),
                title: Text(docs[index]['titulo']),
                subtitle: Text(docs[index]['descripcion']),
                trailing: Text(DateFormat('dd/MM/yyyy')
                    .format(docs[index]['fecha'].toDate())),
              ),
            );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Add(db: db)))
              .then((value) {
            if (value != null) {
              initialise();
            }
          });
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
