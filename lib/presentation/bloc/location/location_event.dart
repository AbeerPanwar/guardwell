import 'package:equatable/equatable.dart';

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
