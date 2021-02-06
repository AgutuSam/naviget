import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:naviget/alert.dart';
import 'package:naviget/auth/auth.dart';
import 'package:naviget/drawer.dart';
import 'package:naviget/secrets.dart'; // Stores the Google Maps API Key
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:naviget/states/model/app_state.dart';
import 'package:naviget/states/redux/actions.dart';
import 'package:naviget/states/redux/reducers.dart';

import 'dart:math' show Random, asin, cos, sqrt;

import 'package:redux/redux.dart';

class MapView extends StatefulWidget {
  MapView({this.auth, this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final Store<AppStates> store = Store<AppStates>(
    reducer,
    initialState: AppStates.initial(),
  );
  @override
  _MapViewState createState() => _MapViewState(store: store);
}

class _MapViewState extends State<MapView> {
  _MapViewState({this.store});
  final Store<AppStates> store;
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  GoogleMapController mapController;

  final CollectionReference databaseMapReference =
      FirebaseFirestore.instance.collection('Maps');
  final CollectionReference userColl =
      FirebaseFirestore.instance.collection('Users');
  final CollectionReference userShared =
      FirebaseFirestore.instance.collection('Shared');

  final Geolocator _geolocator = Geolocator();

  Position _currentPosition;
  String _currentAddress;
  List<List> latLangs = [];
  List<List> marcers = [];

  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();
  final markerController = TextEditingController();
  final startMarkerController = TextEditingController();
  final _mapformKey = GlobalKey<FormState>();
  final _pointformKey = GlobalKey<FormState>();
  final mapName = TextEditingController();
  final pointName = TextEditingController();
  final pointLoc = TextEditingController();

  String _startAddress = '';
  String _destinationAddress = '';
  String _placeDistance;

  PolylinePoints polylinePoints;
  Set<Polyline> polylines = {};
  List<LatLng> myPolylines;
  Set<Marker> markers = {};
  List<LatLng> polylineCoordinates = [];

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  StreamSubscription<Position> _positionStreamSubscription;

  bool extrasVisible;
  bool markerVisible;
  bool startVisible;
  bool stopVisible;
  bool markerFormVisible;
  bool startFormVisible;
  Set<Circle> circles;

  Map<String, dynamic> data;

  User auser;

  Widget _textField({
    TextEditingController controller,
    String label,
    String hint,
    double width,
    Icon prefixIcon,
    Widget suffixIcon,
    Function(String) locationCallback,
  }) {
    return Container(
      width: width * 0.8,
      child: TextField(
        onChanged: (value) {
          locationCallback(value);
        },
        controller: controller,
        decoration: new InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.grey[400],
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.orange[300],
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.all(15),
          hintText: hint,
        ),
      ),
    );
  }

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

  // Method for retrieving the address
  _getAddress() async {
    try {
      List<Placemark> p = await _geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
        startAddressController.text = _currentAddress;
        _startAddress = _currentAddress;
      });
    } catch (e) {
      print(e);
    }
  }

  // Method for calculating the distance between two places
  Future<bool> _calculateDistance() async {
    try {
      // Retrieving placemarks from addresses
      List<Placemark> startPlacemark =
          await _geolocator.placemarkFromAddress(_startAddress);
      List<Placemark> destinationPlacemark =
          await _geolocator.placemarkFromAddress(_destinationAddress);

      if (startPlacemark != null && destinationPlacemark != null) {
        // Use the retrieved coordinates of the current position,
        // instead of the address if the start position is user's
        // current position, as it results in better accuracy.
        Position startCoordinates = _startAddress == _currentAddress
            ? Position(
                latitude: _currentPosition.latitude,
                longitude: _currentPosition.longitude)
            : startPlacemark[0].position;
        Position destinationCoordinates = destinationPlacemark[0].position;

        // Start Location Marker
        Marker startMarker = Marker(
          markerId: MarkerId('$startCoordinates'),
          position: LatLng(
            startCoordinates.latitude,
            startCoordinates.longitude,
          ),
          infoWindow: InfoWindow(
            title: 'Start',
            snippet: _startAddress,
          ),
          icon: BitmapDescriptor.defaultMarker,
        );

        // Destination Location Marker
        Marker destinationMarker = Marker(
          markerId: MarkerId('$destinationCoordinates'),
          position: LatLng(
            destinationCoordinates.latitude,
            destinationCoordinates.longitude,
          ),
          infoWindow: InfoWindow(
            title: 'Destination',
            snippet: _destinationAddress,
          ),
          icon: BitmapDescriptor.defaultMarker,
        );

        // Adding the markers to the list
        // markers.add(startMarker);
        // markers.add(destinationMarker);

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

        await _createPolylines(startCoordinates, destinationCoordinates);

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
  _createPolylines(Position start, Position destination) async {
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Secrets.API_KEY, // Google Maps API Key
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.transit,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );
    polylines.add(polyline);
  }

  void _signedOut() {
    try {
      widget.onSignedOut();
    } catch (e) {
      print(e.toString());
    }
  }

  startMarking() {
    markPoint(startMarkerController.text != null
        ? startMarkerController.text
        : _currentAddress);
    polylineCoordinates
        .add(LatLng(_currentPosition.latitude, _currentPosition.longitude));
    _geolocator
        .getPositionStream(
            LocationOptions(distanceFilter: 1, timeInterval: 3000))
        .listen((Position position) {
      polylineCoordinates.add(LatLng(position.latitude, position.longitude));
      // latLangs.add([position.latitude, position.longitude]);
      PolylineId id = PolylineId('poly');
      Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.red,
        points: polylineCoordinates,
        width: 3,
      );
      polylines.add(polyline);
    });
  }

  markPoint(String name) {
    _geolocator.getCurrentPosition().then((value) {
      markers.add(Marker(
        markerId: MarkerId(Random().nextInt(500).toString()),
        position: LatLng(value.latitude, value.longitude),
        infoWindow: InfoWindow(
          title: name,
          snippet: _currentAddress,
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));

      String randomID = Random().nextInt(500).toString();
      marcers.add(
          // 'markerId': MarkerId(randomID),
          // 'position':
          //     LatLng(value.latitude, value.longitude),
          // 'title': pointName.text,
          // 'address': _currentAddress,
          [
            {
              'name': pointName.text,
              'mkID': randomID,
              'address': _currentAddress,
              'lat': value.latitude,
              'long': value.longitude
            }
          ]);
    });
  }

  stopMarking(List<List> pollies) {
    // saveMap(pollies);

    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );
    polylines.add(polyline);
    // initState();
  }

  saveMap(List<List> myPollies, List<List> myMarcers) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Form(
            key: _mapformKey,
            child: AlertDialog(
              title: Text('Map Name'),
              content: Container(
                height: MediaQuery.of(context).size.height * 0.2,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Point Name cannot be Null!';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.blue),
                        controller: pointName,
                        decoration: new InputDecoration(
                          prefixIcon: Icon(Icons.not_listed_location),
                          labelText: 'Point Name',
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            borderSide: BorderSide(
                              color: Colors.black54,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            borderSide: BorderSide(
                              color: Colors.black54,
                              width: 2,
                            ),
                          ),
                          contentPadding: EdgeInsets.all(15),
                          hintText: 'Custom point name!',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Name cannot be Null!';
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.blue),
                        controller: mapName,
                        decoration: new InputDecoration(
                          prefixIcon: Icon(Icons.map_outlined),
                          labelText: 'Map Name',
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            borderSide: BorderSide(
                              color: Colors.black54,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            borderSide: BorderSide(
                              color: Colors.black54,
                              width: 2,
                            ),
                          ),
                          contentPadding: EdgeInsets.all(15),
                          hintText: 'Custom map name!',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                MaterialButton(
                  onPressed: () async {
                    final formState = _mapformKey.currentState;
                    if (formState.validate()) {
                      try {
                        List pol = myPollies.asMap().entries.map((widget) {
                          return {widget.key.toString(): widget.value};
                        }).toList();

                        String randomID = Random().nextInt(500).toString();
                        _geolocator.getCurrentPosition().then((value) {
                          myMarcers.add(
                              // 'markerId': MarkerId(randomID),
                              // 'position':
                              //     LatLng(value.latitude, value.longitude),
                              // 'title': pointName.text,
                              // 'address': _currentAddress,
                              [
                                {
                                  'name': pointName.text,
                                  'mkID': randomID,
                                  'address': _currentAddress,
                                  'lat': value.latitude,
                                  'long': value.longitude
                                }
                              ]);
                        });
                        List mac = myMarcers.asMap().entries.map((widget) {
                          return {widget.key.toString(): widget.value};
                        }).toList();
                        databaseMapReference.add({
                          mapName.text: {
                            'Polies': pol,
                            'Markers': mac,
                            'User': auser.uid,
                            'UserName': auser.displayName,
                            'UserEmail': auser.email,
                          }
                        });

                        Navigator.pop(context);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return BeautifulAlertDialog(
                                'Map has been added successfully!',
                              );
                            });
                      } catch (e) {
                        e.message != null
                            ? showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return BeautifulAlertDialog(e.message);
                                })
                            : print('e.message is null');
                        // print(e.message);
                      }
                    }
                  },
                  child: Text('Submit',
                      style: TextStyle(color: Colors.blue, fontSize: 22)),
                  elevation: 5.0,
                ),
              ],
            ),
          );
        });
  }

  sendLoc(List point, String address) {
    final _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();

    String getRandomString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

    var gen = getRandomString(8);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Form(
            key: _pointformKey,
            child: AlertDialog(
              title: Text('Email'),
              content: TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Email cannot be Null!';
                  }
                  return null;
                },
                style: TextStyle(color: Colors.blue),
                controller: pointLoc,
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: TextStyle(color: Colors.blue.shade500),
                ),
              ),
              actions: <Widget>[
                MaterialButton(
                  onPressed: () async {
                    final formState = _pointformKey.currentState;
                    if (formState.validate()) {
                      try {
                        userShared
                            .doc(gen.toString())
                            .get()
                            .then((DocumentSnapshot documentSnapshot) {
                          if (!documentSnapshot.exists) {
                            userShared.doc(gen.toString()).set({
                              'Sender': auser.email.toString(),
                              'Reciever': pointLoc.text,
                              'Marker': point,
                              'Address': address.toString(),
                            });
                          }
                        });
                        Navigator.pop(context);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return BeautifulAlertDialog(
                                'Point has been Shared successfully!',
                              );
                            });
                      } catch (e) {
                        e.message != null
                            ? showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return BeautifulAlertDialog(e.message);
                                })
                            : print('e.message is null');
                        // print(e.message);
                      }
                    }
                  },
                  child: Text('Submit',
                      style: TextStyle(color: Colors.blue, fontSize: 22)),
                  elevation: 5.0,
                ),
              ],
            ),
          );
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
    
    data = {'UserType': 'guest'};
    myPolylines = [];
    extrasVisible = false;
    markerVisible = false;
    stopVisible = false;
    startVisible = true;
    markerFormVisible = false;
    startFormVisible = false;
    super.initState();
    _getCurrentLocation();
    _getAddress();
    widget.auth.currentUser().then((user) {
      userColl.doc(user.uid).get().then((value) {
        setState(() {
          data = value.data();
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return StoreProvider<AppStates>(
      store: store,
      child: Container(
        height: height,
        width: width,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: Color(0xFF000050),
            title: Center(
                child: Text(
              'SSUC Navigation',
              style: TextStyle(color: (Colors.white)),
            )),
            actions: <Widget>[
              StoreConnector<AppStates, bool>(
                converter: (Store<AppStates> store) =>
                    store.state.extrasVisible,
                builder: (BuildContext context, bool extrasVisible) {
                  return Visibility(
                    visible: data['UserType'] == 'admin' ? true : false,
                    child: IconButton(
                        icon: Icon(Icons.map),
                        color: Colors.white,
                        onPressed: () {
                          StoreProvider.of<AppStates>(context)
                              .dispatch(Extraz());
                        }),
                  );
                },
              ),
            ],
            iconTheme: IconThemeData(color: Colors.white),
          ),
          drawer: PrimeDrawer(auth: widget.auth, onSignedOut: _signedOut),
          body: Stack(
            children: <Widget>[
              StoreConnector<AppStates, Set<Polyline>>(
                converter: (Store<AppStates> store) => store.state.polylines,
                builder: (BuildContext context, Set<Polyline> polylines) {
                  return
                      // Map View
                      GoogleMap(
                    markers: store.state.markers != null
                        ? store.state.markers
                        : null,
                    initialCameraPosition: _initialLocation,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    mapType: MapType.normal,
                    zoomGesturesEnabled: true,
                    zoomControlsEnabled: false,
                    indoorViewEnabled: true,
                    // polylines: [store.state.polylines],
                    polylines: Set<Polyline>.of(store.state.polylines),
                    onMapCreated: (GoogleMapController controller) {
                      mapController = controller;
                    },
                    // circles: circles,
                  );
                },
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
              // Show the place input fields & button for
              // showing the route
              SafeArea(
                child: StoreConnector<AppStates, bool>(
                  converter: (Store<AppStates> store) =>
                      store.state.extrasVisible,
                  builder: (BuildContext context, bool extrasVisible) {
                    return Visibility(
                      visible: extrasVisible,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20.0),
                              ),
                            ),
                            width: width * 0.9,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, bottom: 10.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  SizedBox(height: 10),
                                  StoreConnector<AppStates, bool>(
                                    converter: (Store<AppStates> store) =>
                                        store.state.startVisible,
                                    builder: (BuildContext context,
                                        bool startVisible) {
                                      return Visibility(
                                        visible: store.state.startVisible,
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.only(
                                              left: 30.0, right: 30.0),
                                          child: ButtonTheme(
                                              child: RaisedButton.icon(
                                                  color: Colors.blueAccent,
                                                  onPressed: () {
                                                    StoreProvider.of<AppStates>(
                                                            context)
                                                        .dispatch(Starter());
                                                  },
                                                  icon: Icon(
                                                      Icons.directions_walk,
                                                      color: Colors.white70),
                                                  label: Text('Start',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .white70)))),
                                        ),
                                      );
                                    },
                                  ),
                                  StoreConnector<AppStates, bool>(
                                    converter: (Store<AppStates> store) =>
                                        store.state.startFormVisible,
                                    builder: (BuildContext context,
                                        bool startFormVisible) {
                                      return Visibility(
                                        visible: startFormVisible,
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(15.0),
                                          child: Column(
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                padding: EdgeInsets.only(
                                                    left: 30.0, right: 30.0),
                                                child: TextFormField(
                                                  controller:
                                                      startMarkerController,
                                                  decoration:
                                                      new InputDecoration(
                                                    prefixIcon: Icon(Icons
                                                        .not_listed_location),
                                                    labelText: 'Point Name',
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(10.0),
                                                      ),
                                                      borderSide: BorderSide(
                                                        color: Colors.black54,
                                                        width: 2,
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(10.0),
                                                      ),
                                                      borderSide: BorderSide(
                                                        color: Colors.black54,
                                                        width: 2,
                                                      ),
                                                    ),
                                                    contentPadding:
                                                        EdgeInsets.all(15),
                                                    hintText:
                                                        'Give custom name to this point!',
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 2,
                                              ),
                                              Container(
                                                width: double.infinity,
                                                padding: EdgeInsets.only(
                                                    left: 30.0, right: 30.0),
                                                child: RaisedButton(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                                  color: Colors.green.shade500,
                                                  onPressed: () {
                                                    StoreProvider.of<AppStates>(
                                                            context)
                                                        .dispatch(StartMarking(
                                                      currentAddress:
                                                          _currentAddress,
                                                      currentPosition:
                                                          _currentPosition,
                                                      geolocator: _geolocator,
                                                      name:
                                                          startMarkerController
                                                              .text,
                                                    ));
                                                  },
                                                  elevation: 11,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  12.0))),
                                                  child: Text("Add Kick Off",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.white70)),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 2,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  StoreConnector<AppStates, bool>(
                                    converter: (Store<AppStates> store) =>
                                        store.state.markerVisible,
                                    builder: (BuildContext context,
                                        bool markerVisible) {
                                      return Visibility(
                                        visible: store.state.markerVisible,
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.only(
                                              left: 30.0, right: 30.0),
                                          child: ButtonTheme(
                                              child: RaisedButton.icon(
                                                  color: Colors.blueAccent,
                                                  onPressed: () {
                                                    StoreProvider.of<AppStates>(
                                                            context)
                                                        .dispatch(Marcer());
                                                  },
                                                  icon: Icon(
                                                      Icons.not_listed_location,
                                                      color: Colors.white70),
                                                  label: Text('Add Marker',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .white70)))),
                                        ),
                                      );
                                    },
                                  ),
                                  StoreConnector<AppStates, bool>(
                                    converter: (Store<AppStates> store) =>
                                        store.state.markerFormVisible,
                                    builder: (BuildContext context,
                                        bool markerFormVisible) {
                                      return Visibility(
                                        visible: store.state.markerFormVisible,
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(15.0),
                                          child: Column(
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                padding: EdgeInsets.only(
                                                    left: 30.0, right: 30.0),
                                                child: TextFormField(
                                                  controller: markerController,
                                                  decoration:
                                                      new InputDecoration(
                                                    prefixIcon: Icon(Icons
                                                        .not_listed_location),
                                                    labelText: 'Point Name',
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(10.0),
                                                      ),
                                                      borderSide: BorderSide(
                                                        color: Colors.black54,
                                                        width: 2,
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(10.0),
                                                      ),
                                                      borderSide: BorderSide(
                                                        color: Colors.black54,
                                                        width: 2,
                                                      ),
                                                    ),
                                                    contentPadding:
                                                        EdgeInsets.all(15),
                                                    hintText:
                                                        'Give custom name to this point!',
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 2,
                                              ),
                                              Container(
                                                width: double.infinity,
                                                padding: EdgeInsets.only(
                                                    left: 30.0, right: 30.0),
                                                child: RaisedButton(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                                  color: Colors.green.shade500,
                                                  onPressed: () {
                                                    StoreProvider.of<AppStates>(
                                                            context)
                                                        .dispatch(MarkPoint(
                                                      geolocator: _geolocator,
                                                      currentAddress:
                                                          _currentAddress,
                                                      name:
                                                          markerController.text,
                                                    ));
                                                  },
                                                  elevation: 11,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  12.0))),
                                                  child: Text("Add",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.white70)),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 2,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  StoreConnector<AppStates, bool>(
                                    converter: (Store<AppStates> store) =>
                                        store.state.stopVisible,
                                    builder: (BuildContext context,
                                        bool stopVisible) {
                                      return Visibility(
                                        visible: store.state.stopVisible,
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.only(
                                              left: 30.0, right: 30.0),
                                          child: ButtonTheme(
                                            child: StoreConnector<AppStates,
                                                    List>(
                                                converter:
                                                    (Store<AppStates> store) =>
                                                        store.state.latLangs,
                                                builder: (BuildContext context,
                                                    List latLngs) {
                                                  return RaisedButton.icon(
                                                      color: Colors.blueAccent,
                                                      onPressed: () {
                                                        // myPolylines =
                                                        //     polylineCoordinates;
                                                        // stopMarking(latLangs);
                                                        StoreProvider.of<
                                                                    AppStates>(
                                                                context)
                                                            .dispatch(
                                                                StopMarking(
                                                          geolocator:
                                                              _geolocator,
                                                          currentAddress:
                                                              _currentAddress,
                                                          mapformKey:
                                                              _mapformKey,
                                                          pointName: pointName,
                                                          auser: auser,
                                                          context: context,
                                                          mapName: mapName,
                                                          databaseMapReference:
                                                              databaseMapReference,
                                                          myMarcers: store
                                                              .state.marcers,
                                                          myPollies: store
                                                              .state.latLangs,
                                                        ));
                                                      },
                                                      icon: Icon(
                                                          Icons.accessibility,
                                                          color:
                                                              Colors.white70),
                                                      label: Text('Stop',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)));
                                                }),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              StoreConnector<AppStates, bool>(
                  converter: (Store<AppStates> store) =>
                      store.state.floatsVisible,
                  builder: (BuildContext context, bool floatsVisible) {
                    return Visibility(
                      visible: store.state.floatsVisible,
                      child: SafeArea(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 10.0, bottom: 150.0),
                            child: ClipOval(
                              child: Material(
                                color: Colors.orange[100], // button color
                                child: InkWell(
                                  splashColor: Colors.orange, // inkwell color
                                  child: SizedBox(
                                    width: 56,
                                    height: 56,
                                    child: Icon(Icons.reply),
                                  ),
                                  onTap: () {
                                    _geolocator
                                        .getCurrentPosition()
                                        .then((value) {
                                      sendLoc([value.latitude, value.longitude],
                                          _currentAddress);
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
              StoreConnector<AppStates, bool>(
                  converter: (Store<AppStates> store) =>
                      store.state.floatsVisible,
                  builder: (BuildContext context, bool floatsVisible) {
                    return Visibility(
                      visible: store.state.floatsVisible,
                      child: SafeArea(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 10.0, bottom: 80.0),
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
                    );
                  }),
              // Show current location button
              StoreConnector<AppStates, bool>(
                  converter: (Store<AppStates> store) =>
                      store.state.floatsVisible,
                  builder: (BuildContext context, bool floatsVisible) {
                    return SafeArea(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(right: 10.0, bottom: 10.0),
                          child: ClipOval(
                            child: Material(
                              color: Colors.orange[100], // button color
                              child: InkWell(
                                splashColor: Colors.orange, // inkwell color
                                child: SizedBox(
                                  width: 56,
                                  height: 56,
                                  child: Icon(Icons.add),
                                ),
                                onTap: () {
                                  StoreProvider.of<AppStates>(context)
                                      .dispatch(Floats());
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
