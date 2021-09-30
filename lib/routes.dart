import 'package:flutter/material.dart';
import 'package:naviget/routeView.dart';
import 'package:naviget/search.dart';
import 'package:naviget/shared/point.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:naviget/auth/auth.dart';

class Routes extends StatefulWidget {
  const Routes({
    this.auth,
    Key key,
  }) : super(key: key);
  final BaseAuth auth;

  @override
  _RoutesState createState() => _RoutesState();
}

class _RoutesState extends State<Routes> with TickerProviderStateMixin {
  AnimationController animationController;
  final CollectionReference userMaps =
      FirebaseFirestore.instance.collection('Maps');
  User auser;
  List<Point> thePoint;
  bool search;
  TextEditingController searchController;

  final List list = List.generate(10, (index) => 'Text $index');

  user() async {
    final User thisuser = await widget.auth.currentUser();
    setState(() {
      auser = thisuser;
    });
  }

  @override
  void initState() {
    search = false;
    user();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<List> getData() async {
    List<Point> _data = [];
    userMaps.get().then((value) {
      var _tabList = value.docs.asMap().entries.map((widget) {
        return widget.key;
      }).toList();
      Map prods = value.docs.asMap();
      print('****************************');
      print(prods[0]['map.Markers'][0]['name']);
      print(_tabList.toString());
      print('****************************');
      for (int i = 0; i < _tabList.length; i++) {
        // if (prods[_tabList[i]]['map.mapName']
        //     .contains(searchController?.text)) {
        prods[i]['map.Markers'].forEach((mrk) {
          _data.add(Point(
            name: '${mrk['name']}',
            org: '${mrk['address']}',
            latlng: [mrk['lat'], mrk['long']],
          ));
        });
        // }
      }
      setState(() {
        thePoint = _data;
      });
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));

    return _data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child:
                Text('Search Point', style: TextStyle(color: (Colors.white)))),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              color: Colors.white,
              onPressed: () {
                showSearch(
                    context: context, delegate: Search(widget.auth, thePoint));
              }),
        ],
        actionsIconTheme: IconThemeData(color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: !false,
        backgroundColor: Color(0xFF000050),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: SingleChildScrollView(
          child: FutureBuilder<List>(
            future: getData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.4),
                  child: Container(
                      child: Center(child: CircularProgressIndicator())),
                );
              } else {
                return Stack(
                  children: [
                    Container(
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: List<Widget>.generate(
                            thePoint.length,
                            (int index) {
                              animationController.forward();
                              return Card(
                                child: FlatButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RouteView(
                                                auth: widget.auth,
                                                buddyPoint:
                                                    thePoint[index].latlng,
                                              )),
                                    );
                                  },
                                  child: ListTile(
                                    title: Text(thePoint[index].name),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
