import 'package:geolocator/geolocator.dart';

abstract class LocationRepository {
  Future<Position> getCurrentLocation();
  Future<bool> isLocationServiceEnabled();
  Future<LocationPermission> checkLocationPermission();
  Future<LocationPermission> requestLocationPermission();
}