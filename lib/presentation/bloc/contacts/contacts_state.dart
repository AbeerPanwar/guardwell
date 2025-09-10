import 'package:equatable/equatable.dart';
import 'package:guardwell/domain/entities/emergency_contact.dart';

abstract class ContactsState extends Equatable {
  const ContactsState();
  @override
  List<Object?> get props => [];
}

class ContactsInitial extends ContactsState {
  const ContactsInitial();
}

class ContactsLoading extends ContactsState {
  const ContactsLoading();
}

class ContactsLoaded extends ContactsState {
  final List<EmergencyContact> contacts;
  const ContactsLoaded(this.contacts);
  @override
  List<Object?> get props => [contacts];
}

class ContactsFailure extends ContactsState {
  final String message;
  const ContactsFailure(this.message);
  @override
  List<Object?> get props => [message];
}
