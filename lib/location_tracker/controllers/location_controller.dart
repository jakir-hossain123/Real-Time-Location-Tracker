import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../services/location_service.dart';

class LocationController {
  final LocationService _locationService;

  LocationController(this._locationService);

  Timer? locationTimer;
  LatLng? currentLocation;
  bool isLoading = true;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  List<LatLng> locationHistory = [];

  void startLocationUpdates(void Function() onUpdate) {
    locationTimer?.cancel();

    locationTimer = Timer.periodic(
      const Duration(seconds: 10),
      (timer) async {
        try {
          if (!await _locationService.isLocationServiceEnabled()) {
            return;
          }

          final permission = await _locationService.checkPermission();

          if (permission == LocationPermission.denied ||
              permission == LocationPermission.deniedForever) {
            return;
          }

          final position = await _locationService.getCurrentPosition();
          final newLocation = LatLng(position.latitude, position.longitude);

          currentLocation = newLocation;
          locationHistory.add(newLocation);
          markers = {
            Marker(
              markerId: const MarkerId('current_location'),
              position: newLocation,
              infoWindow: InfoWindow(
                title: 'My current location',
                snippet: 'Lat: ${position.latitude}, Lng: ${position.longitude}',
              ),
            ),
          };

          if (locationHistory.length >= 2) {
            polylines = {
              Polyline(
                polylineId: const PolylineId('location_tracking'),
                points: List<LatLng>.from(locationHistory),
                color: Colors.blue,
                width: 5,
              ),
            };
          }

          onUpdate();
        } catch (_) {
        }
      },
    );
  }

  Future<void> getCurrentLocation(
    Future<void> Function() onLocationUnavailable,
    void Function() onUpdate,
  ) async {
    try {
      LocationPermission permission = await _locationService.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await _locationService.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        isLoading = false;
        onUpdate();
        return;
      }

      final serviceEnabled = await _locationService.isLocationServiceEnabled();

      if (!serviceEnabled) {
        isLoading = false;
        await onLocationUnavailable();
        onUpdate();
        return;
      }

      final position = await _locationService.getCurrentPosition();
      final location = LatLng(position.latitude, position.longitude);

      currentLocation = location;
      isLoading = false;
      locationHistory = [location];
      markers = {
        Marker(
          markerId: const MarkerId('current_location'),
          position: location,
          infoWindow: InfoWindow(
            title: 'My current location',
            snippet: 'Lat: ${position.latitude}, Lng: ${position.longitude}',
          ),
        ),
      };

      onUpdate();
    } catch (_) {
      isLoading = false;
      onUpdate();
    }
  }

  void dispose() {
    locationTimer?.cancel();
  }
}
