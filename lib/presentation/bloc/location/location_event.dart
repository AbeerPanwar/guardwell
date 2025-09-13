import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();
  @override
  List<Object?> get props => [];
}

class LoadLocation extends LocationEvent {
  const LoadLocation();
}

class RefreshLocation extends LocationEvent {
  const RefreshLocation();
}

class StartLiveLocationEvent extends LocationEvent {}

class StopLiveLocationEvent extends LocationEvent {}

class StartSosLocationEvent extends LocationEvent {}
class StopSosLocationEvent extends LocationEvent {}

class LiveLocationInternalEvent extends LocationEvent {
  final Position position;
  final bool isSos;
  const LiveLocationInternalEvent(this.position, {this.isSos = false});
}