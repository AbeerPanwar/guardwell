import 'package:equatable/equatable.dart';

abstract class SosState extends Equatable {
  const SosState();
  @override
  List<Object?> get props => [];
}

class SosIdle extends SosState {
  const SosIdle();
}

class SosSending extends SosState {
  const SosSending();
}

class SosSuccess extends SosState {
  final int recipients;
  const SosSuccess(this.recipients);
  @override
  List<Object?> get props => [recipients];
}

class SosFailure extends SosState {
  final String message;
  const SosFailure(this.message);
  @override
  List<Object?> get props => [message];
}
