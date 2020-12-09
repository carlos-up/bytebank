import 'dart:async';
import 'package:bytebank/models/pedido.dart';
import 'package:bytebank/services/novo_pedido.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListaPedidos extends StatefulWidget {
  @override
  _ListaPedidosState createState() => _ListaPedidosState();
}

class _ListaPedidosState extends State<ListaPedidos> {
  String name = "";
  String searchString;

  List<Pedido> items;
  var db = FirebaseFirestore.instance;

  StreamSubscription<QuerySnapshot> pedidoInstricao;

  @override
  void initState() {
    super.initState();

    items = List();
    pedidoInstricao?.cancel();

    pedidoInstricao = db.collection("pedidos").snapshots().listen(
      (snapshot) {
        final List<Pedido> pedidos = snapshot.docs
            .map(
              (documentSnapshot) =>
                  Pedido.fromMap(documentSnapshot.data(), documentSnapshot.id),
            )
            .toList();

        setState(() {
          this.items = pedidos;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Pedidos'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchString = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: getListaPedidos(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    return new ListView(
                      children: snapshot.data.docs.map<Widget>(
                        (document) {
                          return new ListTile(
                            title: new Text(
                              document['nome'],
                              style: TextStyle(fontSize: 22),
                            ),
                            subtitle: new Text(document['preco'],
                                style: TextStyle(fontSize: 22)),
                            trailing: Column(
                              children: <Widget>[
                                IconButton(
                                  icon:
                                      const Icon(Icons.delete_forever_rounded),
                                  onPressed: () async {
                                    await db
                                        .collection('pedidos')
                                        .doc(document.id)
                                        .delete();
                                  },
                                ),
                              ],
                            ),
                            onTap: () => _navegarParaPedido(
                              context,
                              Pedido(
                                document.id,
                                document['nome'],
                                document['preco'],
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.grey[900],
        onPressed: () => _criarNovoPedido(context, Pedido(null, '', '')),
      ),
    );
  }

  Stream<QuerySnapshot> getListaPedidos() {
    return (searchString == null || searchString.trim() == "")
        ? FirebaseFirestore.instance.collection("pedidos").snapshots()
        : FirebaseFirestore.instance
            .collection("pedidos")
            .where("searchIndex", arrayContains: searchString)
            .snapshots();
  }

  void _criarNovoPedido(BuildContext context, Pedido pedido) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NovoPedido(Pedido(null, '', ''))),
    );
  }

  void _navegarParaPedido(BuildContext context, Pedido pedido) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NovoPedido(pedido)),
    );
  }
}
