import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guardwell/domain/usecases/location/get_current_location.dart';
import 'package:guardwell/presentation/bloc/location/location_event.dart';
import 'package:guardwell/presentation/bloc/location/location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final GetCurrentLocation getCurrentLocation;
  LocationBloc({required this.getCurrentLocation}) : super(const LocationInitial()) {
    on<LoadLocation>(_onLoad);
    on<RefreshLocation>(_onLoad);
  }

  Future<void> _onLoad(LocationEvent event, Emitter<LocationState> emit) async {
    emit(const LocationLoading());
    try {
      final position = await getCurrentLocation();
      emit(LocationLoaded(position));
    } catch (e) {
      emit(const LocationFailure('Failed to get current location. Please check location permissions.'));
    }
  }
}
