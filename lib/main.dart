import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:naviget/auth/auth.dart';
import 'package:naviget/auth/route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Land A Land',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: RoutePage(auth: Auth()),
    );
  }
}
