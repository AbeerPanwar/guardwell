import 'package:geolocator/geolocator.dart';
import 'package:guardwell/data/services/location_service.dart';
import 'package:guardwell/domain/repositories/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationService locationService;

  LocationRepositoryImpl(this.locationService);

  @override
  Future<Position> getCurrentLocation() => locationService.getCurrentPosition();

  @override
  Future<bool> isLocationServiceEnabled() => locationService.isLocationServiceEnabled();

  @override
  Future<LocationPermission> checkLocationPermission() => locationService.checkPermission();

  @override
  Future<LocationPermission> requestLocationPermission() => locationService.requestPermission();
  
  @override
  Stream<Position> getLiveLocation() => locationService.getLiveLocation();
}