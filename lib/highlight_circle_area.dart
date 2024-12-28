import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_live_location_tracking/constants.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HighlightCircleArea extends StatefulWidget {
  const HighlightCircleArea({Key? key}) : super(key: key);

  @override
  State<HighlightCircleArea> createState() => HighlightCircleAreaState();
}

class HighlightCircleAreaState extends State<HighlightCircleArea> {
  final Completer<GoogleMapController> _controller = Completer();

  LocationData? currentLocation;

  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  void getCurrentLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    Location location = Location();

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    location.getLocation().then(
      (location) {
        currentLocation = location;
        setState(() {});
      },
    );

  }


  @override
  void initState() {
    getCurrentLocation();
    setCustomMarkerIcon();
    super.initState();
  }

  void setCustomMarkerIcon() {
    BitmapDescriptor.asset(ImageConfiguration.empty, 'assets/ic_pin_source.png')
        .then(
      (icon) {
        currentLocationIcon = icon;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Circle Highlight Area",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: currentLocation == null
          ? Center(child: Text('Loading...'))
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                  target: LatLng(
                      currentLocation!.latitude!, currentLocation!.longitude!),
                  zoom: 14.5),
              markers: {
                Marker(
                    icon: currentLocationIcon,
                    markerId: MarkerId('1'),
                    position: LatLng(currentLocation!.latitude!,
                        currentLocation!.longitude!)),
              },
              circles: {
                Circle(
                  circleId: CircleId('1'),
                  center: LatLng(
                      currentLocation!.latitude!, currentLocation!.longitude!),
                  radius: 630,
                  fillColor: Color(0xFF006491).withOpacity(0.2),
                  strokeWidth: 2,
                )
              },
              onMapCreated: (mapController) {
                _controller.complete(mapController);
              },
            ),
    );
  }
}
