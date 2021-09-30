import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:naviget/auth/auth.dart';

class GetCurrenctLocation {}

class GetAddress {}

class CalculateDistance {}

class CoordinateDistance {}

class CreatePolylines {}

class SignedOut {}

class StartMarking {
  StartMarking({
    this.currentPosition,
    this.geolocator,
    this.currentAddress,
    this.name,
  });
  final Position currentPosition;
  final Geolocator geolocator;
  final String name;
  final String currentAddress;
}

class MarkPoint {
  MarkPoint({
    this.geolocator,
    this.currentAddress,
    this.name,
  });
  final Geolocator geolocator;
  final String name;
  final String currentAddress;
}

class StopMarking {
  StopMarking({
    this.currentAddress,
    this.mapformKey,
    this.myMarcers,
    this.pointName,
    this.geolocator,
    this.myPollies,
    this.auth,
    this.auser,
    this.context,
    this.databaseMapReference,
    this.mapName,
  });
  final User auser;
  final List<List> myMarcers;
  final String currentAddress;
  final TextEditingController pointName;
  final Geolocator geolocator;
  final List<List> myPollies;
  final BuildContext context;
  final TextEditingController mapName;
  final CollectionReference databaseMapReference;
  final BaseAuth auth;
  final GlobalKey mapformKey;
}

class SaveMap {}

class Extraz {}

class Starter {}

class Marcer {}

class Floats {}
