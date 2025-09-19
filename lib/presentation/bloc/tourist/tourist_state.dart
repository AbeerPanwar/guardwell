part of 'tourist_cubit.dart';

abstract class TouristState {}

class TouristInitial extends TouristState {}
class TouristLoading extends TouristState {}
class TouristSuccess extends TouristState {}
class TouristFailure extends TouristState {
  final String message;
  TouristFailure(this.message);
}