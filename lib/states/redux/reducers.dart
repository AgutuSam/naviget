import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:naviget/alert.dart';
import 'package:naviget/states/model/app_state.dart';
import 'package:naviget/states/redux/actions.dart';

AppStates reducer(AppStates prev, dynamic action) {
  if (action is StartMarking) {
    var randomID = Random().nextInt(500).toString();
    prev.polyID = PolylineId(DateTime.now().toString());
    action.geolocator.getCurrentPosition().then((value) {
      prev.markers.add(Marker(
        markerId: MarkerId(randomID),
        position: LatLng(value.latitude, value.longitude),
        infoWindow: InfoWindow(
          title: action.name,
          snippet: action.currentAddress,
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));

      prev.marcers.add([
        {
          'name': action.name,
          'mkID': randomID,
          'address': action.currentAddress,
          'lat': value.latitude,
          'long': value.longitude
        }
      ]);
    });
    prev.getPositionSubscription = action.geolocator
        .getPositionStream(
            LocationOptions(distanceFilter: 1, timeInterval: 3000))
        .listen((Position position) {
      prev.polylineCoordinates
          .add(LatLng(position.latitude, position.longitude));
      prev.latLangs.add([position.latitude, position.longitude]);

      Polyline polyline = Polyline(
        polylineId: prev.polyID,
        color: Colors.red,
        points: prev.polylineCoordinates,
        width: 3,
      );
      prev.polylines.add(polyline);
    });
    prev.startFormVisible = !prev.startFormVisible;
    prev.markerVisible = !prev.markerVisible;
  } else if (action is MarkPoint) {
    var randomID = Random().nextInt(500).toString();
    action.geolocator.getCurrentPosition().then((value) {
      prev.markers.add(Marker(
        markerId: MarkerId(randomID),
        position: LatLng(value.latitude, value.longitude),
        infoWindow: InfoWindow(
          title: action.name,
          snippet: action.currentAddress,
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));

      prev.marcers.add([
        {
          'name': action.name,
          'mkID': randomID,
          'address': action.currentAddress,
          'lat': value.latitude,
          'long': value.longitude
        }
      ]);
    });
    prev.markerFormVisible = !prev.markerFormVisible;
    prev.markerVisible = !prev.markerFormVisible;
  } else if (action is StopMarking) {
    showDialog(
        context: action.context,
        builder: (BuildContext context) {
          return Form(
            key: action.mapformKey,
            child: AlertDialog(
              title: Text('Map Name'),
              content: Container(
                height: MediaQuery.of(context).size.height * 0.085,
                child: Column(
                  children: <Widget>[
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
                        controller: action.mapName,
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
                    // if (formState.validate()) {
                    try {
                      List pol = prev.latLangs.asMap().entries.map((widget) {
                        return {
                          'lat': widget.value.first,
                          'lng': widget.value.last
                        };
                      }).toList();

                      // String randomID = Random().nextInt(500).toString();
                      // action.geolocator.getCurrentPosition().then((value) {
                      //   prev.marcers.add([
                      //     {
                      //       'name': action.pointName.text,
                      //       'mkID': randomID,
                      //       'address': action.currentAddress,
                      //       'lat': value.latitude,
                      //       'long': value.longitude
                      //     }
                      //   ]);
                      // });
                      List mac = prev.marcers.asMap().entries.map((widget) {
                        return widget.value.first;
                      }).toList();
                      action.databaseMapReference.add({
                        'map': {
                          'mapName': action.mapName.text,
                          'Polies': pol,
                          'Markers': mac,
                          'User': action.auser.uid,
                          'UserName': action.auser.displayName,
                          'UserEmail': action.auser.email,
                        }
                      });
                      prev.getPositionSubscription?.cancel();
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
                    // }
                  },
                  child: Text('Submit',
                      style: TextStyle(color: Colors.blue, fontSize: 22)),
                  elevation: 5.0,
                ),
              ],
            ),
          );
        });
  } else if (action is Extraz) {
    prev.extrasVisible = !prev.extrasVisible;
  } else if (action is Floats) {
    prev.floatsVisible = !prev.floatsVisible;
  } else if (action is Starter) {
    prev.startVisible = !prev.startVisible;
    prev.stopVisible = !prev.stopVisible;
    prev.startFormVisible = !prev.startFormVisible;
  } else if (action is Marcer) {
    prev.markerFormVisible = !prev.markerFormVisible;
  }
  return prev;
}
