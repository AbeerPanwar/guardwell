part of 'getdata_cubit.dart';

sealed class GetDataState extends Equatable {
  const GetDataState();

  @override
  List<Map<String, dynamic>> get props => [];
}

final class GetDataInitial extends GetDataState {}

class GetdataLoading extends GetDataState {}

class GetDataLoaded extends GetDataState {
  final Map<String, dynamic> user;
  const GetDataLoaded(this.user);
  @override
  List<Map<String, dynamic>> get props => [user];
}

class GetDataError extends GetDataState {
  final String message;
  const GetDataError(this.message);
}
