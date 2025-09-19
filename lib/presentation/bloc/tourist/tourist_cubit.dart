import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guardwell/domain/entities/tourist.dart';
import 'package:guardwell/domain/usecases/tourist/create_tourist.dart';

part 'tourist_state.dart';

class TouristCubit extends Cubit<TouristState> {
  final CreateTourist createTourist;

  TouristCubit(this.createTourist) : super(TouristInitial());

  Future<void> create(Tourist tourist) async {
    emit(TouristLoading());
    try {
      await createTourist(tourist);
      emit(TouristSuccess());
    } catch (e) {
      emit(TouristFailure(e.toString()));
    }
  }
}
