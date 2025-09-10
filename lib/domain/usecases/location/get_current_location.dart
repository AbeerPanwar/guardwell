import 'package:geolocator/geolocator.dart';
import 'package:guardwell/domain/repositories/location_repository.dart';

class GetCurrentLocation {
  final LocationRepository repository;

  GetCurrentLocation(this.repository);

  Future<Position> call() => repository.getCurrentLocation();
}