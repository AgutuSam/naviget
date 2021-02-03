import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:naviget/auth/auth.dart';
import 'package:naviget/shared/buddyView.dart';
import 'package:naviget/shared/team.dart';

class BuddiesList extends StatefulWidget {
  const BuddiesList({
    this.auth,
    Key key,
  }) : super(key: key);
  final BaseAuth auth;
  @override
  _BuddiesListState createState() => _BuddiesListState();
}

class _BuddiesListState extends State<BuddiesList>
    with TickerProviderStateMixin {
  AnimationController animationController;
  final CollectionReference userColl =
      FirebaseFirestore.instance.collection('Shared');
  User auser;
  List<Team> theTeam;

  user() async {
    final User thisuser = await widget.auth.currentUser();
    setState(() {
      auser = thisuser;
    });
  }

  @override
  void initState() {
    user();
    theTeam = [];
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<List> getData() async {
    List<Team> _data = [];
    userColl
        .where('Reciever', isEqualTo: auser.email.toString())
        .get()
        .then((value) {
      var _tabList = value.docs.asMap().entries.map((widget) {
        return widget.key;
      }).toList();
      Map prods = value.docs.asMap();
      print('****************************');
      print(_tabList);
      print(_tabList.toString());
      print('****************************');
      for (int i = 0; i < _tabList.length; i++) {
        _data.add(Team(
            name: '${prods[_tabList[i]]['Sender']}',
            org: '${prods[_tabList[i]]['Address']}'));
      }
      setState(() {
        theTeam = _data;
      });
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));

    return _data;
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsIconTheme: IconThemeData(color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: !false,
        title: Text(
          'Buddies',
          style: TextStyle(color: Colors.white),
        ),
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
                return Container(
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: List<Widget>.generate(
                        theTeam.length,
                        (int index) {
                          final int count = theTeam.length;
                          final Animation<double> animation =
                              Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                              parent: animationController,
                              curve: Interval((1 / count) * index, 1.0,
                                  curve: Curves.fastOutSlowIn),
                            ),
                          );
                          animationController.forward();
                          return BuddyView(
                            teamMember: theTeam[index],
                            animation: animation,
                            animationController: animationController,
                            auth: widget.auth,
                          );
                        },
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
