import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controllers/location_controller.dart';
import '../services/location_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with WidgetsBindingObserver {
  final LocationService _locationService = LocationService();
  late final LocationController _locationController;
  GoogleMapController? mapController;

  LatLng? get currentLocation => _locationController.currentLocation;
  bool get isLoading => _locationController.isLoading;
  Set<Marker> get markers => _locationController.markers;
  Set<Polyline> get polylines => _locationController.polylines;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _locationController = LocationController(_locationService);
    _loadLocation();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      _loadLocation();
    }
  }

  Future<void> _loadLocation() async {
    await _locationController.getCurrentLocation(
      showLocationDialog,
      () {
        if (mounted) {
          setState(() {});
        }
      },
    );

    if (mounted && mapController != null && currentLocation != null) {
      await mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(currentLocation!, 16),
      );
    }

    startLocationUpdates();
  }

  void startLocationUpdates() {
    _locationController.startLocationUpdates(() {
      if (!mounted) return;

      setState(() {});

      if (mapController != null && currentLocation != null) {
        mapController!.animateCamera(
          CameraUpdate.newLatLng(currentLocation!),
        );
      }
    });
  }

  Future<void> showLocationDialog() async {
    final shouldOpenSettings = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          surfaceTintColor: Colors.green[400],
          title: const Text('Location Required'),
          content: const Text(
            'Please turn on your device location to track your current position on the map.',
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.red[400],
                backgroundColor: Colors.green[50],
              ),
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[400],
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Turn On'),
            ),
          ],
        );
      },
    );

    if (shouldOpenSettings == true) {
      await _locationService.openLocationSettings();
    }
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (currentLocation != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(currentLocation!, 16),
      );
    }
  }

  @override
  void dispose() {
    mapController?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: const Text('Real-Time Location Tracker'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(23.8103, 90.4125),
              zoom: 12,
            ),
            onMapCreated: onMapCreated,
            myLocationEnabled: false,
            zoomControlsEnabled: true,
            markers: markers,
            polylines: polylines,
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
