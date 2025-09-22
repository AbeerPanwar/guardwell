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
      print('......................................cubitout');
      final user = await getDataService.getUser();
      print('✅ user fetched: $user');
      final notification = await getDataService.getNotification();
      print('✅ notification fetched: $notification');
      print('.......................cubit before emit');
      emit(GetDataLoaded(user, notification));
      print('.......................cubit after emit');
    } catch (e, st) {
      print('❌ Error in fetchUser: $e');
      print(st);
      emit(GetDataError(e.toString()));
    }
  }
}
