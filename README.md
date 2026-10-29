# Real Time Location Tracker

A Flutter app that displays a Google Map, tracks the user's current location, and updates it in real time every 10 seconds.

## Features

- Smooth camera animation to the user's current location
- Real-time location updates every 10 seconds
- Marker that moves with the latest location
- Polyline that draws the route between previous and current positions
- Marker info window showing:
  - Title: My current location
  - Snippet: latitude and longitude

## Project Description

This project demonstrates how to combine Google Maps and Geolocator in Flutter to build a real-time location tracking app. The app requests location permission, checks whether location services are enabled, and then starts updating the current location automatically. The marker and polyline are refreshed on the map as the user moves.

## Getting Started

1. Install Flutter and Dart.
2. Clone the project.
3. Open the project folder in your IDE or terminal.
4. Run the following command:

   flutter pub get

5. Start the app:

   flutter run

## Required Permissions

On Android/iOS, location permission is required for the app to access the device's location services.

## Notes

- The map updates every 10 seconds.
- A polyline is displayed between the saved path points.
- Marker info windows show the current latitude and longitude.
