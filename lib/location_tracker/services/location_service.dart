import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<LocationPermission> checkPermission() async {
    return Geolocator.checkPermission();
  }

  Future<LocationPermission> requestPermission() async {
    return Geolocator.requestPermission();
  }

  Future<bool> isLocationServiceEnabled() async {
    return Geolocator.isLocationServiceEnabled();
  }

  Future<Position> getCurrentPosition() async {
    return Geolocator.getCurrentPosition();
  }

  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }
}
