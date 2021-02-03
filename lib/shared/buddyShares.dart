import 'package:flutter/material.dart';
import 'package:naviget/shared/team.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:naviget/auth/auth.dart';

class Bud extends StatefulWidget {
  const Bud({
    this.auth,
    Key key,
  }) : super(key: key);
  final BaseAuth auth;
  @override
  _BudState createState() => _BudState();
}

class _BudState extends State<Bud> with TickerProviderStateMixin {
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
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));

    return _data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsIconTheme: IconThemeData(color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: !false,
        title: Text(
          'Shared',
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
                          return ModelView(
                            callback: () {},
                            modell: theTeam[index],
                            animation: animation,
                            animationController: animationController,
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

class ModelView extends StatelessWidget {
  const ModelView(
      {Key key,
      this.modell,
      this.animationController,
      this.animation,
      this.callback})
      : super(key: key);

  final VoidCallback callback;
  final Team modell;
  final AnimationController animationController;
  final Animation<dynamic> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation.value), 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: () {},
              child: Card(
                elevation: 10.0,
                margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                child: Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 10.0),
                        margin: EdgeInsets.only(left: 4.0),
                        decoration: BoxDecoration(
                            border: Border(
                                right: BorderSide(
                                    width: 1.5, color: Colors.black26))),
                        child: CircleAvatar(
                          // child: Image.asset(model.imagePath),
                          radius: 14.0,
                          backgroundColor: Colors.white,
                          child: Text(modell.name[0]),
                          // backgroundImage: Image.asset(model.imagePath).image,
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                modell.name,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.0,
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.0,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: modell.org,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
