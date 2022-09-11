import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';

class Database {
  late FirebaseFirestore firestore;
  initiliase() {
    firestore = FirebaseFirestore.instance;
  }

  Future<void> create(String titulo, String descripcion, DateTime fecha) async {
    try {
      await firestore.collection("acciones").add({
        'titulo': titulo,
        'descripcion': descripcion,
        'fecha': fecha,
        'foto': '//',
        'audio': '//'
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> delete(String id) async {
    try {
      await firestore.collection("acciones").doc(id).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<List> read() async {
    QuerySnapshot querySnapshot;
    List docs = [];
    try {
      querySnapshot =
          await firestore.collection('acciones').orderBy('fecha').get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map a = {
            "id": doc.id,
            "titulo": doc['titulo'],
            "descripcion": doc["descripcion"],
            "fecha": doc["fecha"],
            "foto": doc["foto"],
            "audio": doc["audio"],
          };
          docs.add(a);
        }
        return docs;
      }
    } catch (e) {
      print(e);
    }
    return docs;
  }

  Future<void> update(
      String id, String titulo, String descripcion, DateTime fecha) async {
    try {
      //DateTime date = new DateFormat("dd-MM-yyyy").parse(fecha);
      print(fecha);
      await firestore.collection("acciones").doc(id).update(
          {'titulo': titulo, 'descripcion': descripcion, 'fecha': fecha});
    } catch (e) {
      print(e);
    }
  }
}
