import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HighlightPolyline extends StatefulWidget {
  const HighlightPolyline({super.key});

  @override
  State<HighlightPolyline> createState() => _HighlightPolylineState();
}

class _HighlightPolylineState extends State<HighlightPolyline> {

  LatLng myCurrentLocation = const LatLng(21.24091887844609, 72.88076852280706);

  Set<Marker> markers = {};

  final Set<Polyline> _polyline = {};

  List<LatLng> pointOnMap = [
    const LatLng(21.241867, 72.878564),
    const LatLng(21.242117, 72.881166),
    const LatLng(21.243544, 72.880790),
    const LatLng(21.243288, 72.882727),
    const LatLng(21.244475, 72.886986)
  ];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < pointOnMap.length; i++) {
      markers.add(
        Marker(
          markerId: MarkerId(
            i.toString(),
          ),
          position: pointOnMap[i],
          infoWindow: const InfoWindow(
            title: " Place around my Country",
            snippet: " So Beautiful ",
          ),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
      setState(() {
        _polyline.add(
          Polyline(
            polylineId: const PolylineId("Id"),
            points: pointOnMap,
            color: Colors.black87,
          ),
        );
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        polylines: _polyline,
        myLocationButtonEnabled: false,
        markers: markers,
        initialCameraPosition: CameraPosition(
          target: myCurrentLocation,
          zoom: 14,
        ),
      ),
    );
  }
}
