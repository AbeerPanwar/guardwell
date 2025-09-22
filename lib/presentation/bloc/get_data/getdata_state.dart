part of 'getdata_cubit.dart';

sealed class GetDataState extends Equatable {
  const GetDataState();

  @override
  List<Map<String, dynamic>> get props => [];


  List<List<Map<String, dynamic>>> get notificationProps => [];
}

final class GetDataInitial extends GetDataState {}

class GetdataLoading extends GetDataState {}

class GetDataLoaded extends GetDataState {
  final Map<String, dynamic> user;
  final List<Map<String, dynamic>> notification;
  const GetDataLoaded(this.user, this.notification);
  @override
  List<Map<String, dynamic>> get props => [user];
  List<List<Map<String, dynamic>>> get notificationProps => [notification];
}

class GetDataError extends GetDataState {
  final String message;
  const GetDataError(this.message);
}
