import 'package:cloud_firestore/cloud_firestore.dart';

var db = FirebaseFirestore.instance;

String searchString;

Stream<QuerySnapshot> getListaPedidos() {
  return (searchString == null || searchString.trim() == "")
      ? db.collection("pedidos").orderBy("nome").snapshots()
      : db
          .collection("pedidos")
          .where("searchIndex", arrayContains: searchString)
          .snapshots();
}


//teste sub sub sub col
Stream<QuerySnapshot> getListaPedidos1() {
  return (searchString == null || searchString.trim() == "")
      ? db.collection("Romaneios1").orderBy("nome").snapshots()
      : db
          .collection("Romaneios1")
          .where("searchIndex", arrayContains: searchString)
          .snapshots();
}
