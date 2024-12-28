import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geoCoding;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as map_tool;

class HighlightPolygonArea extends StatefulWidget {
  const HighlightPolygonArea({Key? key}) : super(key: key);

  @override
  State<HighlightPolygonArea> createState() => HighlightPolygonAreaState();
}

class HighlightPolygonAreaState extends State<HighlightPolygonArea> {
  final Completer<GoogleMapController> _controller = Completer();

  // LocationData? currentLocation;
  LatLng initialLocation = const LatLng(21.242601, 72.891740);
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;
  String address = 'Fetching address...';

  List<LatLng> polygonPoints = [
    const LatLng(21.237481, 72.877467),
    const LatLng(21.244847, 72.886330),
    const LatLng(21.238401, 72.890754),
    const LatLng(21.236621, 72.881420),
  ];

  bool isInSelectedArea = true;

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

    // location.getLocation().then(
    //   (location) async {
    //     currentLocation = location;
    //     List<geoCoding.Placemark> placeMarks =
    //         await geoCoding.placemarkFromCoordinates(
    //       currentLocation!.latitude!,
    //       currentLocation!.longitude!,
    //     );
    //
    //     geoCoding.Placemark place = placeMarks[0];
    //     address =
    //         '${place.locality}, ${place.administrativeArea}, ${place.country}';
    //     setState(() {});
    //   },
    // );
  }

  @override
  void initState() {
    // getCurrentLocation();
    getAddress();
    setCustomMarkerIcon();
    super.initState();
  }

  void getAddress() async {
    List<geoCoding.Placemark> placeMarks =
        await geoCoding.placemarkFromCoordinates(
      initialLocation.latitude,
      initialLocation.longitude,
    );

    geoCoding.Placemark place = placeMarks[0];
    address =
        '${place.locality}, ${place.administrativeArea}, ${place.country}';
    setState(() {});
  }

  void checkUpdatedLocation(LatLng pointLatLng) {
    List<map_tool.LatLng> convertedPolygonPoints = polygonPoints
        .map((e) => map_tool.LatLng(e.latitude, e.longitude))
        .toList();
    setState(() {
      isInSelectedArea = map_tool.PolygonUtil.containsLocation(
          map_tool.LatLng(pointLatLng.latitude, pointLatLng.longitude),
          convertedPolygonPoints,
          false);
    });
  }

  void setCustomMarkerIcon() async {
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
        title: const Text(
          "Polygon Highlight Area",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                  target: LatLng(
                      initialLocation.latitude, initialLocation.longitude),
                  zoom: 14.5),
              markers: {
                Marker(
                    icon: currentLocationIcon,
                    markerId: const MarkerId('1'),
                    draggable: true,
                    onDragEnd: (updatedLatLang) {
                      initialLocation = updatedLatLang;
                      checkUpdatedLocation(updatedLatLang);
                    },
                    position: LatLng(
                        initialLocation.latitude, initialLocation.longitude)),
              },
              polygons: {
                Polygon(
                    polygonId: const PolygonId('1'),
                    points: polygonPoints,
                    fillColor: const Color(0xFF006491).withOpacity(0.2),
                    strokeWidth: 2)
              },
              onMapCreated: (mapController) {
                _controller.complete(mapController);
              },
            ),
          ),
          Container(
            width: double.infinity,
            height: 200,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Your Location',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                color: isInSelectedArea
                                    ? Colors.blueAccent
                                    : Colors.red,
                                shape: BoxShape.circle),
                            child: const Icon(
                              Icons.location_on_sharp,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(isInSelectedArea
                              ? address
                              : 'This area is not accessible for delivery!')
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                            color: Colors.blueAccent, shape: BoxShape.circle),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: isInSelectedArea ? Colors.blueAccent : Colors.grey),
                            onPressed: () {
                              setState(() {
                                checkUpdatedLocation(initialLocation);
                              });
                            },
                            child: Text(
                              'Confirm Location',
                              style: TextStyle(
                                  color: isInSelectedArea ? Colors.white : Colors.white60,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            )),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
