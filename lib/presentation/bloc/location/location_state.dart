import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

abstract class LocationState extends Equatable {
  const LocationState();
  @override
  List<Object?> get props => [];
}

class LocationInitial extends LocationState {
  const LocationInitial();
}

class LocationLoading extends LocationState {
  const LocationLoading();
}

class LocationLoaded extends LocationState {
  final Position position;
  final String place;
  const LocationLoaded(this.position, this.place);
  @override
  List<Object?> get props => [position, place];
}

class LocationFailure extends LocationState {
  final String message;
  const LocationFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class LiveLocationUpdated extends LocationState {
  final Position position;
  const LiveLocationUpdated(this.position);
}

class SosActiveState extends LocationState {
  final Position initialPosition;
  const SosActiveState(this.initialPosition);
}

class SosStoppedState extends LocationState {}