import 'package:flutter/material.dart';
import 'package:naviget/mapView.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Naviget',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MapView(),
    );
  }
}
