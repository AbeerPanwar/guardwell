import 'package:equatable/equatable.dart';
import 'package:guardwell/domain/entities/emergency_contact.dart';

abstract class ContactsEvent extends Equatable {
  const ContactsEvent();
  @override
  List<Object?> get props => [];
}

class LoadContacts extends ContactsEvent {
  const LoadContacts();
}

class AddEmergencyContactEvent extends ContactsEvent {
  final EmergencyContact contact;
  const AddEmergencyContactEvent(this.contact);
  @override
  List<Object?> get props => [contact];
}

class AddMultipleEmergencyContactsEvent extends ContactsEvent {
  final List<EmergencyContact> contacts;
  const AddMultipleEmergencyContactsEvent(this.contacts);
  @override
  List<Object?> get props => [contacts];
}

class DeleteEmergencyContactEvent extends ContactsEvent {
  final String id;
  const DeleteEmergencyContactEvent(this.id);
  @override
  List<Object?> get props => [id];
}
