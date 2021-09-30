import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  final CollectionReference invDoc =
      FirebaseFirestore.instance.collection('Users');
  List<ListTile> tiles;

  List<ListTile> getDataBody() {
    List<ListTile> _tiles = [];
    invDoc.get().then((value) {
      var _tabList = value.docs.asMap().entries.map((widget) {
        return widget.key;
      }).toList();

      Map prods = value.docs.asMap();
      // List<bool> isSwitched = List.generate(_tabList.length, (index) => false);
      print('****************************');
      print(_tabList);
      print(_tabList.toString());
      print(prods[_tabList[0]]['Email']);
      print('****************************');

      for (int i = 0; i < _tabList.length; i++) {
        _tiles.add(
          ListTile(
            leading: CircleAvatar(
              child: Text('${prods[_tabList[i]]['Email']}'[0]),
            ),
            title: Text('${prods[_tabList[i]]['Email']}'),
            trailing: Switch(
              value: '${prods[_tabList[i]]['UserType']}' == 'admin',
              activeColor: Colors.blue,
              inactiveTrackColor: Colors.blueGrey,
              inactiveThumbColor: Colors.lightBlueAccent,
              onChanged: (bool value) {
                invDoc.doc('${prods[_tabList[i]]['UserId']}').update(
                      '${prods[_tabList[i]]['UserType']}' == 'admin'
                          ? {'UserType': 'guest'}
                          : {'UserType': 'admin'},
                    );
                initState();
              },
            ),
          ),
        );
      }
      setState(() {
        tiles = _tiles;
      });
    });

    return _tiles;
  }

  @override
  void initState() {
    tiles = [];
    getDataBody();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF000050),
        title: Center(
            child: Text(
          'Admin',
          style: TextStyle(color: (Colors.white)),
        )),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: tiles,
        ),
      ),
    );
  }
}
