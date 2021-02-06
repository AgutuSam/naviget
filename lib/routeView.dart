import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:naviget/auth/auth.dart';
import 'package:naviget/drawer.dart';
import 'package:naviget/secrets.dart'; // Stores the Google Maps API Key
import 'package:naviget/states/model/app_state.dart';
import 'package:naviget/states/redux/reducers.dart';

import 'dart:math' show Random, asin, cos, sqrt;

import 'package:redux/redux.dart';

class RouteView extends StatefulWidget {
  RouteView({this.buddyPoint, this.auth, this.onSignedOut});
  final BaseAuth auth;
  final List buddyPoint;
  final VoidCallback onSignedOut;
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
  CameraPosition _initialLocation;
  GoogleMapController mapController;


  final Geolocator _geolocator = Geolocator();

  Position _currentPosition;
  String _currentAddress;
  String _placeDistance;

  PolylinePoints polylinePoints;
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};
  Set<Marker> markers = {};
  

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Set<Circle> circles;

  User auser;


  // Method for retrieving the current location
  _getCurrentLocation() async {
    await _geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
        print('*******CURRENT POS: $_currentPosition');
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
  _calculateDistance(String startAddress, String destinationAddress ) async {
    try {
      // Retrieving placemarks from addresses
      List<Placemark> startPlacemark =
          await _geolocator.placemarkFromAddress(startAddress);
      List<Placemark> destinationPlacemark =
          await _geolocator.placemarkFromAddress(destinationAddress);

      if (startPlacemark != null && destinationPlacemark != null) {
        // Use the retrieved coordinates of the current position,
        // instead of the address if the start position is user's
        // current position, as it results in better accuracy.
        Position startCoordinates = startAddress == _currentAddress
            ? Position(
                latitude: _currentPosition.latitude,
                longitude: _currentPosition.longitude)
            : startPlacemark[0].position;
        Position destinationCoordinates = destinationPlacemark[0].position;


        print('START COORDINATES: $startCoordinates');
        print('DESTINATION COORDINATES: $destinationCoordinates');

        Position _northeastCoordinates;
        Position _southwestCoordinates;

        // Calculating to check that
        // southwest coordinate <= northeast coordinate
        if (startCoordinates.latitude <= destinationCoordinates.latitude) {
          _southwestCoordinates = startCoordinates;
          _northeastCoordinates = destinationCoordinates;
        } else {
          _southwestCoordinates = destinationCoordinates;
          _northeastCoordinates = startCoordinates;
        }

        // Accommodate the two locations within the
        // camera view of the map
        mapController.animateCamera(
          CameraUpdate.newLatLngBounds(
            LatLngBounds(
              northeast: LatLng(
                _northeastCoordinates.latitude,
                _northeastCoordinates.longitude,
              ),
              southwest: LatLng(
                _southwestCoordinates.latitude,
                _southwestCoordinates.longitude,
              ),
            ),
            100.0,
          ),
        );

        // Calculating the distance between the start and the end positions
        // with a straight path, without considering any route
        // double distanceInMeters = await Geolocator().bearingBetween(
        //   startCoordinates.latitude,
        //   startCoordinates.longitude,
        //   destinationCoordinates.latitude,
        //   destinationCoordinates.longitude,
        // );

        await _createPolylines();

        double totalDistance = 0.0;

        // Calculating the total distance by adding the distance
        // between small segments
        for (int i = 0; i < polylineCoordinates.length - 1; i++) {
          totalDistance += _coordinateDistance(
            polylineCoordinates[i].latitude,
            polylineCoordinates[i].longitude,
            polylineCoordinates[i + 1].latitude,
            polylineCoordinates[i + 1].longitude,
          );
        }

        setState(() {
          _placeDistance = totalDistance.toStringAsFixed(2);
          print('DISTANCE: $_placeDistance km');
        });

        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  // Formula for calculating distance between two coordinates
  // https://stackoverflow.com/a/54138876/11910277
  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  // Create the polylines for showing the route between two places
  _createPolylines() async {
    polylinePoints = PolylinePoints();
    _geolocator.getCurrentPosition().then((value) async{
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Secrets.API_KEY, // Google Maps API Key
      PointLatLng(value.latitude, value.longitude),
      PointLatLng(widget.buddyPoint.first, widget.buddyPoint.last),
      travelMode: TravelMode.transit,
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
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );
    polylines[id] = polyline;
  }

  void _signedOut() {
    try {
      widget.onSignedOut();
    } catch (e) {
      print(e.toString());
    }
  }

 _setMarkers() async{
   await _geolocator.getCurrentPosition().then((value) async {
   List<Placemark> startp = await _geolocator.placemarkFromCoordinates(
          value.latitude, value.longitude);
   List<Placemark> endp = await _geolocator.placemarkFromCoordinates(
          widget.buddyPoint.first, widget.buddyPoint.last);

      Placemark start = startp[0];
      Placemark end = endp[0];

        String _startAddress =
            "${start.name}, ${start.locality}, ${start.postalCode}, ${start.country}";
        String _endAddress =
            "${end.name}, ${end.locality}, ${end.postalCode}, ${end.country}";
      
   
   markers.add(
     Marker(
  markerId: MarkerId('$_startAddress'),
  position: LatLng(
    value.latitude,
    value.longitude,
  ),
  infoWindow: InfoWindow(
    title: 'Start',
    snippet: _startAddress,
  ),
  icon: BitmapDescriptor.defaultMarker,

   ),
   );
  
   markers.add(
     Marker(
  markerId: MarkerId('$_endAddress'),
  position: LatLng(
    widget.buddyPoint.first,
    widget.buddyPoint.last,
  ),
  infoWindow: InfoWindow(
    title: 'Start',
    snippet: _endAddress,
  ),
  icon: BitmapDescriptor.defaultMarker,

   ),
   );
_calculateDistance(_startAddress, _endAddress);
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
    return  Container(
        height: height,
        width: width,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: Color(0xFF000050),
            title: Center(
                child: Text( _placeDistance == null ?
              'SSUC Navigation' : 'DISTANCE: $_placeDistance km',
              style: TextStyle(color: (Colors.white)),
            )),
           
            iconTheme: IconThemeData(color: Colors.white),
          ),
          drawer: PrimeDrawer(auth: widget.auth, onSignedOut: _signedOut),
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
                            padding: const EdgeInsets.only(
                                right: 10.0, bottom: 10.0),
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
