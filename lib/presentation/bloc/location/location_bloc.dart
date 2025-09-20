import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
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
    on<StartSosLocationEvent>(_onStartSosLocation);
    on<StopSosLocationEvent>(_onStopSosLocation);
    on<LiveLocationInternalEvent>(_onLiveLocationInternal);
  }

  Future<void> _onLoad(LocationEvent event, Emitter<LocationState> emit) async {
    emit(const LocationLoading());
    try {
      String initialplace = '';
      final position = await getCurrentLocation();
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        print('inside.......................');
        Placemark place = placemarks.first;
        initialplace = "${place.name}, ${place.locality}, ${place.country}";
        print(initialplace);
      } else {
        initialplace = "No place found for the given coordinates";
      }
      emit(LocationLoaded(position, initialplace));
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
      add(LiveLocationInternalEvent(position, isSos: true));
    });
  }

  Future<void> _onStopLiveLocation(
    StopLiveLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    await _liveLocationSubscription?.cancel();
    emit(LocationInitial());
  }

  Future<void> _onStartSosLocation(
    StartSosLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    await _liveLocationSubscription?.cancel();
    final pos = await locationRepository.getCurrentLocation();
    await locationRepository.sendSos(pos);

    emit(SosActiveState(pos));

    _liveLocationSubscription = locationRepository.getLiveLocation().listen((
      position,
    ) {
      add(LiveLocationInternalEvent(position, isSos: true));
    });
  }

  Future<void> _onStopSosLocation(
    StopSosLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    await _liveLocationSubscription?.cancel();
    emit(LocationInitial());
    emit(SosStoppedState());
  }

  Future<void> _onLiveLocationInternal(
    LiveLocationInternalEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(LiveLocationUpdated(event.position));
    if (event.isSos) {
      await locationRepository.updateSos(event.position);
    }
  }

  @override
  Future<void> close() {
    _liveLocationSubscription?.cancel();
    return super.close();
  }
}
