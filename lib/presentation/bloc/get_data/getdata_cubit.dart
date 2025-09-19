import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guardwell/data/services/get_data.dart';

part 'getdata_state.dart';

class GetDataCubit extends Cubit<GetDataState> {
  final GetDataService getDataService;
  GetDataCubit(this.getDataService) : super(GetDataInitial());

  Future<void> fetchUser() async {
    emit(GetdataLoading());
    try {
      final user = await getDataService.getUser();
      emit(GetDataLoaded(user));
    } catch (e) {
      emit(GetDataError(e.toString()));
    }
  }
}
