import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_live_location_tracking/constants.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({Key? key}) : super(key: key);

  @override
  State<OrderTrackingPage> createState() => OrderTrackingPageState();
}

class OrderTrackingPageState extends State<OrderTrackingPage> {
  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
  static const LatLng destination = LatLng(37.33429383, -122.06600055);

  static const LatLng initialLocation = LatLng(37.334221, -122.036308);

  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;
  double _currentHeading = 0.0;
  final MarkerId _markerId = MarkerId('live_location');
  final MarkerId _sourceMarkerId = MarkerId('source_location');
  final MarkerId _destinationMarkerId = MarkerId('destination_location');
  Map<MarkerId, Marker> _markers = {};

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
        _initializeMarkers();
        setState(() {});
      },
    );

    GoogleMapController googleMapController = await _controller.future;
    location.onLocationChanged.listen(
      (newLoc) {
        currentLocation = newLoc;
        _currentHeading = newLoc.heading!;
        _updateMarker();
        googleMapController
            .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(zoom: 14.5, target: LatLng(newLoc.latitude!, newLoc.longitude!))));
        setState(() {});
      },
    );
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        request: PolylineRequest(
            origin: PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
            destination: PointLatLng(destination.latitude, destination.longitude),
            mode: TravelMode.driving),
        googleApiKey: google_api_key);

    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => polylineCoordinates.add(LatLng(point.latitude, point.longitude)),
      );
      setState(() {});
    }
  }

  @override
  void initState() {
    getCurrentLocation();
    setCustomMarkerIcon();
    getPolyPoints();
    super.initState();
  }

  void setCustomMarkerIcon() {
    BitmapDescriptor.asset(ImageConfiguration.empty, 'assets/ic_pin_source.png').then(
      (icon) {
        sourceIcon = icon;
      },
    );
    BitmapDescriptor.asset(ImageConfiguration.empty, 'assets/ic_pin_destination.png').then(
      (icon) {
        destinationIcon = icon;
      },
    );
    BitmapDescriptor.asset(ImageConfiguration.empty, 'assets/ic_navigation.png').then(
      (icon) {
        currentLocationIcon = icon;
      },
    );
  }

  void _initializeMarkers() {
    _markers[_sourceMarkerId] = Marker(markerId: _sourceMarkerId, position: sourceLocation, icon: sourceIcon);
    _markers[_markerId] =
        Marker(markerId: _markerId, position: LatLng(currentLocation!.latitude!, currentLocation!.longitude!), icon: currentLocationIcon);
    _markers[_destinationMarkerId] = Marker(markerId: _destinationMarkerId, position: destination, icon: destinationIcon);
  }

  void _updateMarker() {
    Marker liveLocationMarker = Marker(
        markerId: _markerId,
        position: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
        icon: currentLocationIcon,
        rotation: _currentHeading,
        flat: true);
    _markers[_markerId] = liveLocationMarker;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Live Location Tracking",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: currentLocation == null
          ? Center(child: Text('Loading...'))
          : GoogleMap(
              /// Uncomment For Device Live Location
              initialCameraPosition: CameraPosition(target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!), zoom: 14.5),

              /// For Custom Location with map latitude and longitude
              // initialCameraPosition: CameraPosition(target: LatLng(initialLocation.latitude, initialLocation.longitude), zoom: 14.5),
              polylines: {
                Polyline(polylineId: PolylineId('route'), points: polylineCoordinates, color: Colors.black87, width: 6),
              },
              /*markers: {
                Marker(
                    icon: currentLocationIcon,
                    markerId: MarkerId('currentLocation'),
                    /// Uncomment For Device Live Location
                    position: LatLng(currentLocation!.latitude!, currentLocation!.longitude!)

                    /// For Custom Location with map latitude and longitude
                    // position: LatLng(initialLocation.latitude, initialLocation.longitude)

                ),

                Marker(icon: sourceIcon, markerId: MarkerId('source'), position: sourceLocation),
                Marker(icon: destinationIcon, markerId: MarkerId('destination'), position: destination),
              },*/
              markers: Set<Marker>.of(_markers.values),
              onMapCreated: (mapController) {
                _controller.complete(mapController);
                _updateMarker();
              },
            ),
    );
  }
}
