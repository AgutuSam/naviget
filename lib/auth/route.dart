import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:naviget/auth/auth.dart';
import 'package:naviget/auth/signin.dart';
import 'package:naviget/mapView.dart';

class RoutePage extends StatefulWidget {
  RoutePage({this.auth});
  final BaseAuth auth;
  @override
  State<StatefulWidget> createState() => _RoutePageState();
}

enum AuthStatus { notSignedIn, signedIn }

class _RoutePageState extends State<RoutePage> {
  AuthStatus authStatus = AuthStatus.notSignedIn;
  final databaseReference = FirebaseFirestore.instance.collection('Users');

  @override
  initState() {
    super.initState();
    widget.auth.currentUser().then((user) => setState(() {
          authStatus =
              user.uid == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
        }));
  }

  void _signedIn() {
    widget.auth.currentUser().then((user) {
      databaseReference
          .doc(user.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (!documentSnapshot.exists) {
          print('******************************88');
          print('******************************88');
          print('******************************88');

          databaseReference.doc(user.uid).set({
            'Email': user.email,
            'UserId': user.uid,
            'UserType': 'admin',
          });
        }
      });
    });

    setState(() {
      authStatus = AuthStatus.signedIn;
    });
  }

  void _signedOut() {
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        return SignIn(auth: widget.auth, onSignedIn: _signedIn);
      case AuthStatus.signedIn:
        return MapView(auth: widget.auth, onSignedOut: _signedOut);
    }
  }
}
