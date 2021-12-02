import 'package:flutter/material.dart';
import 'package:naviget/catalogue/Posted.dart';
import 'package:naviget/catalogue/bought.dart';
import 'package:naviget/catalogue/pending.dart';
import 'package:naviget/catalogue/sold.dart';

class Catalogue extends StatefulWidget {
  const Catalogue({Key key}) : super(key: key);

  @override
  _CatalogueState createState() => _CatalogueState();
}

class _CatalogueState extends State<Catalogue> {
  int _currentIndex = 0;
  final List _children = [Pending(), Posted(), Bought(), Sold()];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catalogue'),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white38,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: onTabTapped,
        currentIndex:
            _currentIndex, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.pending_sharp),
            label: 'Pending',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.post_add),
            label: 'Posted',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_basket), label: 'Bought'),
          BottomNavigationBarItem(icon: Icon(Icons.sell), label: 'Sold')
        ],
      ),
    );
  }
}
