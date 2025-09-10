import 'package:flutter_contacts/flutter_contacts.dart' as fc;
import 'package:equatable/equatable.dart';

abstract class SystemContactsState extends Equatable {
  const SystemContactsState();
  @override
  List<Object?> get props => [];
}

class SystemContactsInitial extends SystemContactsState {
  const SystemContactsInitial();
}

class SystemContactsLoading extends SystemContactsState {
  const SystemContactsLoading();
}

class SystemContactsLoaded extends SystemContactsState {
  final List<fc.Contact> contacts;
  const SystemContactsLoaded(this.contacts);

  @override
  List<Object?> get props => [contacts];
}

class SystemContactsFailure extends SystemContactsState {
  final String message;
  const SystemContactsFailure(this.message);

  @override
  List<Object?> get props => [message];
}
