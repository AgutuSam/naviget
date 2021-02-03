import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
    this.auth,
    this.context,
    this.databaseMapReference,
    this.mapName,
  });
  final BuildContext context;
  final String mapName;
  final CollectionReference databaseMapReference;
  final BaseAuth auth;
}

class SaveMap {}

class Extraz {}

class Starter {}

class Marcer {}

class Floats {}
