import 'dart:async';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppStates {
  AppStates({
    this.initialLocation,
    this.mapController,
    this.currentPosition,
    this.currentAddress,
    this.latLangs,
    this.marcers,
    this.startAddress,
    this.destinationAddress,
    this.placeDistance,
    this.polylinePoints,
    this.polylines,
    this.myPolylines,
    this.markers,
    this.polylineCoordinates,
    this.positionStreamSubscription,
    this.extrasVisible,
    this.markerVisible,
    this.startVisible,
    this.stopVisible,
    this.markerFormVisible,
    this.startFormVisible,
    this.circles,
    this.data,
  });

  factory AppStates.initial() => AppStates(
        initialLocation: CameraPosition(target: LatLng(0.0, 0.0)),
        latLangs: [],
        marcers: [],
        startAddress: '',
        destinationAddress: '',
        polylines: {},
        markers: {},
        polylineCoordinates: [],
        extrasVisible: false,
        markerVisible: false,
        startVisible: true,
        stopVisible: false,
        markerFormVisible: false,
        startFormVisible: false,
      );

  CameraPosition initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  GoogleMapController mapController;
  Position currentPosition;
  String currentAddress;
  List<List> latLangs = [];
  List<List> marcers = [];
  String startAddress = '';
  String destinationAddress = '';
  String placeDistance;
  PolylinePoints polylinePoints;
  Set<Polyline> polylines = {};
  List<LatLng> myPolylines;
  Set<Marker> markers = {};
  List<LatLng> polylineCoordinates = [];
  StreamSubscription<Position> positionStreamSubscription;
  bool extrasVisible;
  bool markerVisible;
  bool startVisible;
  bool stopVisible;
  bool markerFormVisible;
  bool startFormVisible;
  Set<Circle> circles;
  Map<String, dynamic> data;
}