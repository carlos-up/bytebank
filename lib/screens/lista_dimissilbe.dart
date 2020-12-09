import 'dart:async';
import 'package:bytebank/models/pedido.dart';
import 'package:bytebank/services/getlista.dart';
import 'package:bytebank/services/novo_pedido.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListaDimissible extends StatefulWidget {
  @override
  _ListaDimissibleState createState() => _ListaDimissibleState();
}

class _ListaDimissibleState extends State<ListaDimissible> {
  String name = "";
  var _controller = TextEditingController();
  String _chosenValue;
  String _chosenValue2;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Pedido> items;

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
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).list),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            iconSize: 22,
            color: Colors.white,
            onPressed: _displaySnackBar,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {} /*_controller.clear()*/,
                ),
                /*suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () => countDocuments() /*_controller.clear()*/,
                ),*/
              ),
              style: TextStyle(fontSize: 22),
              onChanged: (value) {
                setState(() {
                  searchString = value.toLowerCase();
                });
              },
            ),
          ),
          Divider(),
          Title(
              color: Colors.white,
              child: Text(AppLocalizations.of(context).changelist,
                  style: TextStyle(fontSize: 18))),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DropdownButton<String>(
                value: _chosenValue2,
                //elevation: 5,
                style: TextStyle(color: Colors.white),
                items: <String>[
                  'nome',
                  'preco',
                  /*AppLocalizations.of(context).price,
                  AppLocalizations.of(context).name,*/
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                hint: Text(
                  AppLocalizations.of(context).listtype,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                onChanged: (String value) {
                  setState(() {
                    _chosenValue2 = value;
                  });
                },
              ),
              DropdownButton<String>(
                value: _chosenValue,
                //elevation: 5,
                style: TextStyle(color: Colors.white),
                items: <String>[
                  'nome',
                  'preco',
                  /*AppLocalizations.of(context).price,
                  AppLocalizations.of(context).name,*/
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                hint: Text(
                  AppLocalizations.of(context).listtype,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                onChanged: (String value) {
                  setState(() {
                    _chosenValue = value;
                  });
                },
              ),
            ],
          ),
          Divider(),
          Expanded(
            child: SizedBox(
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
                      return SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: new ListView(
                            children: snapshot.data.docs.map(
                              (document) {
                                final item = document['nome'];
                                return new Dismissible(
                                  key: Key(item),
                                  onDismissed: (direction) async {
                                    await db
                                        .collection('pedidos')
                                        .doc(document.id)
                                        .delete();
                                  },
                                  background: Container(
                                    color: Colors.red,
                                    child: Align(
                                      alignment: Alignment(-0.9, 0),
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  child: new ListTile(
                                    title: new Text(
                                      document[_chosenValue2],
                                      style: TextStyle(fontSize: 22),
                                    ),
                                    subtitle: new Text(document[_chosenValue],
                                        style: TextStyle(fontSize: 22)),
                                    onTap: () => _navegarParaPedido(
                                      context,
                                      Pedido(
                                        document.id,
                                        document['nome'],
                                        document['preco'],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                        ),
                      );
                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        //backgroundColor: Color(0xFF003341),
        onPressed: () => _criarNovoPedido(context, Pedido(null, '', '')),
      ),
    );
  }

  /*void countDocuments() async {
    QuerySnapshot _myDoc =
        await FirebaseFirestore.instance.collection('pedidos').get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    var teste = _myDocCount.length.toString();
    print(_myDocCount.length); // Count of Documents in Collection
  }*/

  _criarNovoPedido(BuildContext context, Pedido pedido) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NovoPedido(Pedido(null, '', ''))),
    );
  }

  _navegarParaPedido(BuildContext context, Pedido pedido) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NovoPedido(pedido)),
    );
  }

  _displaySnackBar() async {
    QuerySnapshot _myDoc = await db.collection('pedidos').get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    var teste = _myDocCount.length.toString();
    final snackBar =
        SnackBar(content: Text('Quantidade de produtos cadastrada: $teste'));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
