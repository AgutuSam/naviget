import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:naviget/auth/auth.dart';
import 'package:naviget/auth/signin.dart';
import 'package:naviget/main.dart';
import 'package:naviget/shared/buddiesList.dart';
import 'package:naviget/shared/maps.dart';
import 'package:toast/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin.dart';

class PrimeDrawer extends StatefulWidget {
  PrimeDrawer({this.auth, this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  @override
  State<StatefulWidget> createState() => _PrimeDrawerState();
}

class _PrimeDrawerState extends State<PrimeDrawer> {
  User auser;
  final CollectionReference userColl =
      FirebaseFirestore.instance.collection('Users');
  Map<String, dynamic> data;

  user() async {
    final User thisuser = await widget.auth.currentUser();
    setState(() {
      auser = thisuser;
    });
  }

  @override
  void initState() {
    user();
    super.initState();
    widget.auth.currentUser().then((user) {
      userColl.doc(user.uid).get().then((value) {
        setState(() {
          data = value.data();
        });
      });
    });
    data = {'UserType': 'guest'};
  }

  void _signOut() async {
    try {
      await widget.auth.signOutFireBaseAuth();
      await widget.auth
          .signOutGoogle()
          .whenComplete(() async => await widget.auth.signOutFireBaseAuth());
      widget.onSignedOut();
    } catch (e) {
      Toast.show(e.toString(), context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 80,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xFF0B7DE3),
                              offset: Offset(1.0, 1.0),
                              blurRadius: 8.0)
                        ],
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                            colors: [Color(0xFF0000E2), Color(0xFF0000F0)])),
                    child: CircleAvatar(
                        radius: 44.5,
                        backgroundImage: '${auser?.photoURL}' != null &&
                                // ||
                                '${auser?.photoURL}' != 'null'
                            ? NetworkImage('${auser?.photoURL}')
                            : AssetImage('assets/anonym.jpg')),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    '${auser?.displayName}' != null &&
                            '${auser?.displayName}' != 'null'
                        ? '${auser?.displayName}'
                        : 'Anonymous',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '${auser?.email}' != null
                        ? '${auser?.email}'
                        : 'Anonym@naviget.com',
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                  SizedBox(height: 5.0),
                ],
              ),
            ),
            decoration: BoxDecoration(
                color: Color(0xFF004BE2),
                image: DecorationImage(
                    image: AssetImage('assets/earth.jpg'), fit: BoxFit.cover)),
          ),
          SizedBox(height: 10.0),
          _buildRow(Icons.home, 'Home', context, MyApp()),
          _buildDivider(),
          _buildRow(Icons.account_circle, 'Profile', context, MyApp()),
          _buildDivider(),
          Visibility(
            visible: data['UserType'] == 'admin',
            child: Column(
              children: <Widget>[
                _buildRow(
                    Icons.admin_panel_settings, 'Admin', context, Admin()),
                _buildDivider(),
              ],
            ),
          ),
          _buildRow(
              Icons.forward_rounded,
              'Shared',
              context,
              BuddiesList(
                auth: widget.auth,
              )),
          _buildDivider(),
          _buildRow(Icons.star, 'Maps', context, UniMaps()),
          _buildDivider(),
          _buildRow(Icons.help_outline, 'Help', context, MyApp()),
          _buildDivider(),
          _buildRow(Icons.info_outline, 'Info', context, SignIn()),
          _buildDivider(),
          Container(
            padding: const EdgeInsets.symmetric(vertical: .2),
            child: FlatButton(
              onPressed: () => _signOut(),
              child: Row(children: [
                Icon(
                  Icons.power_settings_new,
                  color: Color(0xFF0000F0),
                ),
                SizedBox(width: 10.0),
                Text(
                  'LogOut',
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                ),
                Spacer(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Divider _buildDivider() {
    return Divider(
      color: Colors.deepOrangeAccent.shade200,
    );
  }

  Widget _buildRow(
      IconData icon, String title, BuildContext context, Widget route,
      {bool showBadge = false}) {
    final TextStyle tStyle = TextStyle(color: Colors.black, fontSize: 16.0);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: .2),
      child: FlatButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => route));
        },
        child: Row(children: [
          Icon(
            icon,
            color: Color(0xFF0000F0),
          ),
          SizedBox(width: 10.0),
          Text(
            title,
            style: tStyle,
          ),
          Spacer(),
          if (showBadge)
            Material(
              color: Colors.deepOrange,
              elevation: 5.0,
              shadowColor: Colors.red,
              borderRadius: BorderRadius.circular(5.0),
              child: Container(
                width: 25,
                height: 25,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Text(
                  '10+',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
        ]),
      ),
    );
  }
}
