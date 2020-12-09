import 'package:bytebank/models/pedido.dart';
import 'package:bytebank/services/novo_produto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NovoPedido extends StatefulWidget {
  final Pedido pedido;
  NovoPedido(this.pedido);

  @override
  _NovoPedidoState createState() => _NovoPedidoState();
}

class _NovoPedidoState extends State<NovoPedido> {
  final db = FirebaseFirestore.instance;

  TextEditingController _nomeController;
  TextEditingController _precoController;

  @override
  void initState() {
    super.initState();
    _nomeController = new TextEditingController(text: widget.pedido.nome);
    _precoController = new TextEditingController(text: widget.pedido.preco);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (widget.pedido.id != null)
            ? Text(AppLocalizations.of(context).editorder)
            : Text(AppLocalizations.of(context).neworder),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(15.0),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nomeController,
              decoration:
                  InputDecoration(labelText: AppLocalizations.of(context).name),
              style: TextStyle(fontSize: 22),
            ),
            TextField(
              controller: _precoController,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).price),
              style: TextStyle(fontSize: 22),
            ),
            SizedBox(
              height: 20,
            ),
            FloatingActionButton.extended(
              label: (widget.pedido.id != null)
                  ? Text(AppLocalizations.of(context).updateorder)
                  : Text(AppLocalizations.of(context).neworder),
              //textColor: Colors.white,
              //color: Color(0xFF003341),
              onPressed: () {
                _addToDatabase1(_nomeController.text, _precoController.text);
                Navigator.pop(context);
                /*if (widget.pedido.id != null) {
                  db.collection("pedidos").doc(widget.pedido.id).set({
                    "nome": _nomeController.text,
                    "preco": _precoController.text,
                  });
                  Navigator.pop(context);
                } else {
                  db.collection("pedidos").doc(widget.pedido.id).set({
                    "nome": _nomeController.text,
                    "preco": _precoController.text,
                  });
                  Navigator.pop(context);
                }*/
              },
              heroTag: "btn1",
            ),
            SizedBox(
              height: 20,
            ),
            Visibility(
              child: FloatingActionButton.extended(
                label: Text(AppLocalizations.of(context).insertproduct),
                heroTag: "btn2",
                onPressed: () => _criarNovoProduto(
                    context, Pedido(widget.pedido.id, '', '')),
              ),
              visible: (widget.pedido.id != null) ? true : false,
            ),
          ],
        ),
      ),
    );
  }

  void _criarNovoProduto(BuildContext context, Pedido pedido) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => NovoProduto(Pedido(widget.pedido.id, '', ''))),
    );
  }

  void _addToDatabase1(String nome, String preco) {
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

    if (widget.pedido.id != null) {
      db.collection('pedidos').doc(widget.pedido.id).set({
        'nome': _nomeController.text,
        'preco': _precoController.text,
        'searchIndex': indexList
      });
    } else {
      db.collection('pedidos').doc(widget.pedido.id).set({
        'nome': _nomeController.text,
        'preco': _precoController.text,
        'searchIndex': indexList
      });
    }

    /*FirebaseFirestore.instance
        .collection('pedidos')
        .doc()
        .set({'nome': nome, 'preco': preco, 'searchIndex': indexList});*/
  }
}
