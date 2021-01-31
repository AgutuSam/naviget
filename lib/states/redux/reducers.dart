import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:naviget/alert.dart';
import 'package:naviget/states/model/app_state.dart';
import 'package:naviget/states/redux/actions.dart';

AppStates reducer(AppStates prev, dynamic action) {
  if (action is StartMarking) {
    action.geolocator.getCurrentPosition().then((value) {
      prev.markers.add(Marker(
        markerId: MarkerId(Random().nextInt(500).toString()),
        position: LatLng(value.latitude, value.longitude),
        infoWindow: InfoWindow(
          title: action.name,
          snippet: action.currentAddress,
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));

      prev.marcers.add([value.latitude, value.longitude]);
    });
    action.geolocator
        .getPositionStream(
            LocationOptions(distanceFilter: 1, timeInterval: 3000))
        .listen((Position position) {
      prev.polylineCoordinates
          .add(LatLng(position.latitude, position.longitude));
      prev.latLangs.add([position.latitude, position.longitude]);
      PolylineId id = PolylineId('poly');
      Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.red,
        points: prev.polylineCoordinates,
        width: 3,
      );
      prev.polylines.add(polyline);
    });
    prev.startFormVisible = !prev.startFormVisible;
    prev.markerVisible = !prev.markerVisible;
  } else if (action is MarkPoint) {
    action.geolocator.getCurrentPosition().then((value) {
      prev.markers.add(Marker(
        markerId: MarkerId(Random().nextInt(500).toString()),
        position: LatLng(value.latitude, value.longitude),
        infoWindow: InfoWindow(
          title: action.name,
          snippet: action.currentAddress,
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));

      prev.marcers.add([value.latitude, value.longitude]);
    });
    prev.markerFormVisible = !prev.markerFormVisible;
    prev.markerVisible = !prev.markerFormVisible;
  } else if (action is StopMarking) {
    action.auth.currentUser().then((user) {
      action.databaseMapReference
          .doc(user.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (!documentSnapshot.exists) {
          List pol = prev.latLangs.asMap().entries.map((widget) {
            return {widget.key.toString(): widget.value};
          }).toList();

          List mac = prev.marcers.asMap().entries.map((widget) {
            return {widget.key.toString(): widget.value};
          }).toList();
          action.databaseMapReference.doc(user.uid).set({
            'Date': DateTime.now(),
            action.mapName: {
              'Polies': pol,
              'Markers': mac,
              'User': user.uid,
              'UserName': user.displayName ?? null,
              'UserEmail': user.email,
            }
          });
        }
      });
    });
    Navigator.pop(action.context);
    showDialog(
        context: action.context,
        builder: (BuildContext context) {
          return BeautifulAlertDialog(
            'Map has been added successfully!',
          );
        });

    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: prev.polylineCoordinates,
      width: 3,
    );
    prev.polylines.add(polyline);
  } else if (action is Extraz) {
    prev.extrasVisible = !prev.extrasVisible;
  } else if (action is Starter) {
    prev.startVisible = !prev.startVisible;
    prev.stopVisible = !prev.stopVisible;
    prev.startFormVisible = !prev.startFormVisible;
  } else if (action is Marcer) {
    prev.markerFormVisible = !prev.markerFormVisible;
  }
  return prev;
}
