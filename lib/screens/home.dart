import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('UpApp'),
          /*actions: <Widget>[
          SizedBox(
            height: 12.0,
            child: IconButton(
                icon: Icon(Icons.toggle_off),
                iconSize: 22,
                color: Colors.white,
                onPressed: () {}),
          )
        ],*/
          centerTitle: true,
        ),
        body: Column(
          children: [
            Column(
              children: <Widget>[
                BottomNavigationBar(
                  selectedFontSize: 14,
                  unselectedFontSize: 14,
                  items: [
                    BottomNavigationBarItem(
                      label: 'Pedidos',
                      icon: Icon(Icons.library_books),
                    ),
                    BottomNavigationBarItem(
                      label: 'Produtos',
                      icon: Icon(Icons.list),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ));
  }
}
