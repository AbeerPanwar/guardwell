import 'package:geolocator/geolocator.dart';

abstract class LocationRepository {
  Future<Position> getCurrentLocation();
  Stream<Position> getLiveLocation();

  Future<void> sendSos(Position position);
  Future<void> updateSos(Position position);

  
  Future<bool> isLocationServiceEnabled();
  Future<LocationPermission> checkLocationPermission();
  Future<LocationPermission> requestLocationPermission();
}