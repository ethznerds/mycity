import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../utils/locationHelper.dart' as loc;

class AroundMe extends StatefulWidget {
  @override
  _AroundMeState createState() => _AroundMeState();
}

class _AroundMeState extends State<AroundMe> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    _gotoCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _initialPos,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        zoomGesturesEnabled: true,
        compassEnabled: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _gotoCurrentLocation,

        child: Icon(Icons.gps_fixed, color: Colors.black,),
        elevation: 1.0,
        mini: true,
        //shape: RoundedRectangleBorder(),
        backgroundColor: Colors.white.withOpacity(0.8),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }

  static final CameraPosition _initialPos = CameraPosition(
    target: LatLng(47.377220, 	8.539902),
    zoom: 5,
  );


  Future<void> _gotoCurrentLocation() async {
    LocationData _location = await loc.getLocation();
    final CameraPosition _locationPos = CameraPosition(
        target: LatLng(_location.latitude, _location.longitude),
        zoom: 14);

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_locationPos));
  }
}
