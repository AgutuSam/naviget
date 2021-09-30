import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:naviget/auth/auth.dart';
import 'package:naviget/secrets.dart'; // Stores the Google Maps API Key
import 'package:naviget/states/model/app_state.dart';
import 'package:naviget/states/redux/reducers.dart';

import 'dart:math' show Random;

import 'package:redux/redux.dart';

class RouteView extends StatefulWidget {
  RouteView({this.buddyPoint, this.auth});
  final BaseAuth auth;
  final List buddyPoint;
  final Store<AppStates> store = Store<AppStates>(
    reducer,
    initialState: AppStates.initial(),
  );
  @override
  _RouteViewState createState() => _RouteViewState(store: store);
}

class _RouteViewState extends State<RouteView> {
  _RouteViewState({this.store});
  final Store<AppStates> store;
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  GoogleMapController mapController;

  final Geolocator _geolocator = Geolocator();

  Position _currentPosition;
  String _placeDistance;

  PolylinePoints polylinePoints;
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};
  Set<Marker> markers = {};

  Set<Circle> circles;

  User auser;

  // Method for retrieving the current location
  _getCurrentLocation() async {
    await _geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
        print('&&*&*&*CURRENT POSITION: $_currentPosition &*&*&*&*&*');
        print('&&*&*&*CURRENT POSITION: ${widget.buddyPoint} &*&*&*&*&*');
        // print('&&*&*&*CURRENT POSITION: ${widget.buddyPoint[1]} &*&*&*&*&*');
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 16.0,
            ),
          ),
        );
        _initialLocation = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 16.0,
        );

        // circles = Set.from([
        //   Circle(
        //     circleId: CircleId('myCircle'),
        //     center: LatLng(position.latitude, position.longitude),
        //     radius: 4000, //*********radius in metres *******/
        //   )
        // ]);
      });
    }).catchError((e) {
      print(e);
    });
  }

  // Method for calculating the distance between two places

  // Formula for calculating distance between two coordinates
  // https://stackoverflow.com/a/54138876/11910277

  // Create the polylines for showing the route between two places
  _createPolylines() async {
    polylinePoints = PolylinePoints();
    _geolocator.getCurrentPosition().then((value) async {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        Secrets.API_KEY, // Google Maps API Key
        PointLatLng(value.latitude, value.longitude),
        PointLatLng(widget.buddyPoint[0], widget.buddyPoint[1]),
        travelMode: TravelMode.walking,
      );

      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      }
    });
    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blueGrey[800],
      points: polylineCoordinates,
      width: 3,
    );
    setState(() {
      polylines[id] = polyline;
    });
  }

  _setMarkers() async {
    await _geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position value) async {
      // List<Placemark> startp = await _geolocator.placemarkFromCoordinates(
      //     value.latitude, value.longitude);
      // List<Placemark> endp = await _geolocator.placemarkFromCoordinates(
      //     widget.buddyPoint[0], widget.buddyPoint[1]);

      // Placemark start = startp[0];
      // Placemark end = endp[0];

      // String _startAddress =
      //     "${start.name}, ${start.locality}, ${start.postalCode}, ${start.country}";
      // String _endAddress =
      //     "${end.name}, ${end.locality}, ${end.postalCode}, ${end.country}";

      // print('OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO');
      // print(_startAddress);
      // print(_endAddress);
      // print('OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO');

      markers.add(
        Marker(
          markerId: MarkerId(Random().nextInt(500).toString()),
          position: LatLng(
            value.latitude,
            value.longitude,
          ),
          infoWindow: InfoWindow(
            title: 'Start',
            snippet: 'Kick Off',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(120.0),
        ),
      );

      markers.add(
        Marker(
          markerId: MarkerId(Random().nextInt(500).toString()),
          position: LatLng(
            widget.buddyPoint[0],
            widget.buddyPoint[1],
          ),
          infoWindow: InfoWindow(
            title: 'End',
            snippet: 'Destination',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(210.0),
        ),
      );
      // _calculateDistance(_startAddress, _endAddress);
    });
  }

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
    _getCurrentLocation();
    _setMarkers();
    _createPolylines();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: height,
      width: width,
      child: Scaffold(
        // key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Color(0xFF000050),
          title: Center(
              child: Text(
            _placeDistance == null
                ? 'SSUC Navigation'
                : 'DISTANCE: $_placeDistance km',
            style: TextStyle(color: (Colors.white)),
          )),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        // drawer: PrimeDrawer(auth: widget.auth, onSignedOut: _signedOut),
        body: Stack(
          children: <Widget>[
            // Map View
            GoogleMap(
              markers: markers != null ? Set<Marker>.from(markers) : null,
              initialCameraPosition: _initialLocation,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              indoorViewEnabled: true,
              polylines: Set<Polyline>.of(polylines.values),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
              // circles: circles,
            ),

            // Show zoom buttons
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipOval(
                      child: Material(
                        color: Colors.orange[100], // button color
                        child: InkWell(
                          splashColor: Colors.orange, // inkwell color
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(Icons.add),
                          ),
                          onTap: () {
                            mapController.animateCamera(
                              CameraUpdate.zoomIn(),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ClipOval(
                      child: Material(
                        color: Colors.orange[100], // button color
                        child: InkWell(
                          splashColor: Colors.orange, // inkwell color
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(Icons.remove),
                          ),
                          onTap: () {
                            mapController.animateCamera(
                              CameraUpdate.zoomOut(),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

            // Show current location button
            SafeArea(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                  child: ClipOval(
                    child: Material(
                      color: Colors.orange[100], // button color
                      child: InkWell(
                        splashColor: Colors.orange, // inkwell color
                        child: SizedBox(
                          width: 56,
                          height: 56,
                          child: Icon(Icons.my_location),
                        ),
                        onTap: () {
                          mapController.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: LatLng(
                                  _currentPosition.latitude,
                                  _currentPosition.longitude,
                                ),
                                zoom: 18.0,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
