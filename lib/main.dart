import 'package:flutter/material.dart';
import 'package:flutter_live_location_tracking/google_map_flutter.dart';
import 'package:flutter_live_location_tracking/highlight_circle_area.dart';
import 'package:flutter_live_location_tracking/highlight_polygon_area.dart';
import 'package:flutter_live_location_tracking/highlight_polyline.dart';
import 'package:flutter_live_location_tracking/maps_custom_info.dart';
import 'package:flutter_live_location_tracking/order_traking_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: OrderTrackingPage(),
    );
  }
}

