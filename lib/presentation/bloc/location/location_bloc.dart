import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:guardwell/domain/repositories/location_repository.dart';
import 'package:guardwell/domain/usecases/location/get_current_location.dart';
import 'package:guardwell/presentation/bloc/location/location_event.dart';
import 'package:guardwell/presentation/bloc/location/location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final GetCurrentLocation getCurrentLocation;
  final LocationRepository locationRepository;
  StreamSubscription<Position>? _liveLocationSubscription;
  LocationBloc(this.locationRepository, {required this.getCurrentLocation})
    : super(const LocationInitial()) {
    on<LoadLocation>(_onLoad);
    on<RefreshLocation>(_onLoad);
    on<StartLiveLocationEvent>(_onStartLiveLocation);
    on<StopLiveLocationEvent>(_onStopLiveLocation);
    on<_LiveLocationInternalEvent>((event, emit) {
      emit(LiveLocationUpdated(event.position));
    });
  }

  Future<void> _onLoad(LocationEvent event, Emitter<LocationState> emit) async {
    emit(const LocationLoading());
    try {
      final position = await getCurrentLocation();
      emit(LocationLoaded(position));
    } catch (e) {
      emit(
        const LocationFailure(
          'Failed to get current location. Please check location permissions.',
        ),
      );
    }
  }

  Future<void> _onStartLiveLocation(
    StartLiveLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    await _liveLocationSubscription?.cancel();
    _liveLocationSubscription = locationRepository.getLiveLocation().listen((
      position,
    ) {
      add(_LiveLocationInternalEvent(position));
    });
  }

  Future<void> _onStopLiveLocation(
    StopLiveLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    await _liveLocationSubscription?.cancel();
  }
}

class _LiveLocationInternalEvent extends LocationEvent {
  final Position position;
  const _LiveLocationInternalEvent(this.position);
}
