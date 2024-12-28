# Google Maps Live Location Tracking in Flutter

This Flutter project demonstrates real-time location tracking using Google Maps, providing a seamless and responsive experience. The app tracks the user’s current location and displays it on a Google Map with dynamic updates as the location changes.

---


## Screenshots

### Live Location Tracking
Screen 1 demo shows live location tracking.
Screen 2 demo shows polyPoints area with order status.

<div style="display: flex; justify-content: space-between;">
  <img src="https://github.com/kamal66/flutter_live_location_tracking/blob/main/screenshots/demo_1.gif?raw=true" width="250" height="auto" alt="Screenshot 1"/>
  <img src="https://github.com/kamal66/flutter_live_location_tracking/blob/main/screenshots/demo_2.gif?raw=true" width="250" height="auto" alt="Screenshot 2"/>
</div>

### PolyPoints Area Highlight
Screen 1 shows highlighted area with circular polyPoints. 
Screen 2 shows polyLines with marker points.

<div style="display: flex; justify-content: space-between;">
  <img src="https://github.com/kamal66/flutter_live_location_tracking/blob/main/screenshots/ss3.png?raw=true" width="250" height="auto" alt="Screenshot 3"/>
  <img src="https://github.com/kamal66/flutter_live_location_tracking/blob/main/screenshots/ss4.png?raw=true" width="250" height="auto" alt="Screenshot 4"/>
</div>

### Custom Info Window

<div style="display: flex; justify-content: space-between;">
  <img src="https://github.com/kamal66/flutter_live_location_tracking/blob/main/screenshots/ss1.png?raw=true" width="250" height="auto" alt="Screenshot 5"/>
  <img src="https://github.com/kamal66/flutter_live_location_tracking/blob/main/screenshots/ss2.png?raw=true" width="250" height="auto" alt="Screenshot 6"/>
</div>

---

## Features ✨

- **Real-Time Location Updates** 
  Tracks the user's current location and updates it on the map in real-time.

- **Google Maps Integration**
  Embeds Google Maps for intuitive location visualization.

- **Customizable Markers** 
  Displays custom markers to represent the user’s live location.

- **Polyline Routes**
  Draws routes on the map to show the user’s movement (if enabled).

- **Custom Info Widget** 
  Displays an interactive and customizable info widget when a marker is tapped, providing additional details like user name, address, or location description.

- **Responsive Design**  
  Fully responsive UI that adapts to various screen sizes and orientations.

---

## Getting Started

Follow these steps to set up the project:

### Prerequisites
1. Install [Flutter](https://flutter.dev/docs/get-started/install) (ensure a valid Flutter environment).
2. Set up a [Google Cloud Console](https://console.cloud.google.com/) project with Maps SDK for Android/iOS enabled.
3. Obtain an API key for Google Maps.

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/kamal66/flutter_live_location_tracking.git
   cd flutter_live_location_tracking
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Add your Google Maps API key:
  - Open `android/app/src/main/AndroidManifest.xml` and insert your API key
    ```xml
    <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="YOUR_API_KEY" />
    ```
  - For iOS, update the `AppDelegate.swift` file with your API key:
    ```swift
    GMSServices.provideAPIKey("YOUR_API_KEY")
    ```
4. Run the app:
   ```bash
   flutter run
   ```

## Customization

- **Marker Icons**: Replace the default marker with custom icons by updating the `BitmapDescriptor` in the `Marker` widget.
- **Polyline Styling**: Customize polyline colors and width in the `Polyline` widget.
- **Custom Info Widget**: Modify the design and content of the info widget by customizing the `InfoWindow` widget.
---


## Contributing

Contributions are welcome! Please fork the repository and submit a pull request with your improvements or bug fixes.

---

## License

This project is licensed under the Apache License. See the [LICENSE](LICENSE.txt).

---

## Acknowledgments

- Google Maps Platform
- Flutter Team  
