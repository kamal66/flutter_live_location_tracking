import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsCustomInfo extends StatefulWidget {
  const MapsCustomInfo({super.key});

  @override
  State<MapsCustomInfo> createState() => _MapsCustomInfoState();
}

class _MapsCustomInfoState extends State<MapsCustomInfo> {
  final CustomInfoWindowController _customInfoWindowController =
  CustomInfoWindowController();

  Set<Marker> markers = {};

  final List<LatLng> latlongPoint = [
    const LatLng(23.584060627023653, 72.13298212966767),
    const LatLng(23.583822607387365, 72.13699139636226),
    const LatLng(23.59181431763662, 72.14495078842845),
  ];

  final List<String> locationNames = [
    "Sun Temple, Modhera",
    "Chalukya era Hawa Mahel Modhera",
    "Shree Modheshwari Mata Temple Modhera",
  ];

  final List<String> locationImages = [
    "https://upload.wikimedia.org/wikipedia/commons/thumb/7/73/Surya_mandhir.jpg/1280px-Surya_mandhir.jpg",
    "https://lh3.googleusercontent.com/p/AF1QipNsEqnHgBo3eHcECEFHgbqvL86iTYna1CxP1kXT=s1360-w1360-h1020",
    "https://www.ravenouslegs.com/uploads/4/2/3/4/42340821/img-1237-pano_orig.jpg",
  ];

  @override
  void initState() {
    super.initState();
    displayInfo();
  }

  displayInfo() {
    for (int i = 0; i < latlongPoint.length; i++) {
      markers.add(
        Marker(
          markerId: MarkerId(i.toString()), // Unique identifier for each marker
          icon: BitmapDescriptor.defaultMarker, // Default marker icon
          position: latlongPoint[i], // Position of the marker
          onTap: () {
            // When marker is tapped, show the custom info window
            _customInfoWindowController.addInfoWindow!(
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white
                  ), // Background color of the info window
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display the corresponding image for the location
                      Image.network(
                        locationImages[i],
                        height: 125,
                        width: 250,
                        fit: BoxFit.cover,
                      ),
                      // const SizedBox(height: 4), // Spacer between image and text
                      // Display the corresponding name for the location

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          locationNames[i],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child:Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 20,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 20,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 20,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 20,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 20,
                            ),
                            Text("(5)")
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              latlongPoint[
              i], // Position where the info window should be displayed
            );
          },
        ),
      );
      setState(() {}); // Update the UI to reflect the added markers
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Custom Info Window",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: Stack(
        children: [
          // GoogleMap widget to display the map
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(
                  23.582305, 72.139454 ),
              zoom: 12,
            ),
            markers: markers,
            onTap: (argument) {
              _customInfoWindowController.hideInfoWindow!();
            },
            onCameraMove: (position) {
              _customInfoWindowController.onCameraMove!();
            },
            onMapCreated: (GoogleMapController controller) {
              _customInfoWindowController.googleMapController = controller;
            },
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 200,
            width: 250,
            offset: 35,
          ),
        ],
      ),
    );
  }
}
