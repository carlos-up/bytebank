import 'package:bytebank/models/pedido.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NovoProduto extends StatefulWidget {
  final Pedido pedido;
  NovoProduto(this.pedido);

  @override
  _NovoProdutoState createState() => _NovoProdutoState();
}

class _NovoProdutoState extends State<NovoProduto> {
  TextEditingController _nomeController1;
  TextEditingController _precoController1;

  final _scaffoldKey1 = GlobalKey<ScaffoldState>();

  final db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _nomeController1 = new TextEditingController(text: widget.pedido.nome);
    _precoController1 = new TextEditingController(text: widget.pedido.preco);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey1,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).newproduct),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(15.0),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nomeController1,
              decoration:
                  InputDecoration(labelText: AppLocalizations.of(context).name),
              style: TextStyle(fontSize: 22),
              //autofocus: true,
            ),
            TextField(
              controller: _precoController1,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).price),
              style: TextStyle(fontSize: 22),
            ),
            SizedBox(
              height: 20,
            ),
            FloatingActionButton.extended(
              label: Text(AppLocalizations.of(context).newproduct),
              //textColor: Colors.white,
              //color: Color(0xFF003341),
              onPressed: () {
                _addColDatabase(_nomeController1.text, _precoController1.text);
                _nomeController1.clear();
                _precoController1.clear();
              },
              heroTag: "btn3",
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Title(
                  color: Colors.white,
                  child: Text(AppLocalizations.of(context).productslist,
                      style: TextStyle(fontSize: 18))),
            ),
            Divider(),
            Expanded(
              child: SizedBox(
                child: StreamBuilder<QuerySnapshot>(
                  stream: db
                      .collection('pedidos')
                      .doc(widget.pedido.id)
                      .collection('produtos')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: new ListView(
                            key: UniqueKey(),
                            children: snapshot.data.docs.map(
                              (document) {
                                final item = document['nome'];
                                return new Dismissible(
                                  key: Key(item),
                                  onDismissed: (direction) async {
                                    await db
                                        .collection('pedidos')
                                        .doc(widget.pedido.id)
                                        .collection('produtos')
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
                                      document['nome'],
                                      style: TextStyle(fontSize: 22),
                                    ),
                                    subtitle: new Text(document['preco'],
                                        style: TextStyle(fontSize: 22)),
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                        ),
                      );
                    }
                    return CircularProgressIndicator();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addColDatabase(String nome, String preco) {
    List<String> splitList = nome.split(" ");

    //index no preco
    //List<String> split1List = preco.split(" ");

    List<String> indexList = [];

    for (int i = 0; i < splitList.length; i++) {
      for (int y = 1; y < splitList[i].length + 1; y++) {
        indexList.add(splitList[i].substring(0, y).toLowerCase());
      }
    }

    //gerar index no preco
    /*for (int i = 0; i < split1List.length; i++) {
      for (int y = 1; y < split1List[i].length + 1; y++) {
        indexList.add(split1List[i].substring(0, y).toLowerCase());
      }
    }*/

    print(indexList);

    /*db.collection('pedidos').doc(widget.pedido.id).set({
      'nome': _nomeController.text,
      'preco': _precoController.text,
      'searchIndex': indexList
    });*/
    DocumentReference reference = db
        .collection('pedidos')
        .doc(widget.pedido.id)
        .collection('produtos')
        .doc();
    reference.set({
      'nome': _nomeController1.text,
      'preco': _precoController1.text,
      'searchIndex': indexList
    });

    /*FirebaseFirestore.instance
        .collection('pedidos')
        .doc()
        .set({'nome': nome, 'preco': preco, 'searchIndex': indexList});*/
  }
}
