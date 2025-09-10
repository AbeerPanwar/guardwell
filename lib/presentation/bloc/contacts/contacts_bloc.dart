import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guardwell/domain/repositories/contact_repository.dart';
import 'package:guardwell/domain/usecases/contacts/delete_emergency_contact.dart';
import 'package:guardwell/domain/usecases/contacts/get_emergency_contacts.dart';
import 'package:guardwell/domain/usecases/contacts/save_emergency_contact.dart';
import 'package:guardwell/presentation/bloc/contacts/contacts_event.dart';
import 'package:guardwell/presentation/bloc/contacts/contacts_state.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  final GetEmergencyContacts getEmergencyContacts;
  final SaveEmergencyContact saveEmergencyContact;
  final DeleteEmergencyContact deleteEmergencyContact;

  ContactsBloc({required ContactRepository repository})
      : getEmergencyContacts = GetEmergencyContacts(repository),
        saveEmergencyContact = SaveEmergencyContact(repository),
        deleteEmergencyContact = DeleteEmergencyContact(repository),
        super(const ContactsInitial()) {
    on<LoadContacts>(_onLoad);
    on<AddEmergencyContactEvent>(_onAdd);
    on<AddMultipleEmergencyContactsEvent>(_onAddMultiple);
    on<DeleteEmergencyContactEvent>(_onDelete);
  }

  Future<void> _onLoad(LoadContacts event, Emitter<ContactsState> emit) async {
    emit(const ContactsLoading());
    try {
      final contacts = await getEmergencyContacts();
      emit(ContactsLoaded(contacts));
    } catch (e) {
      emit(const ContactsFailure('Failed to load emergency contacts.'));
    }
  }

  Future<void> _onAdd(AddEmergencyContactEvent event, Emitter<ContactsState> emit) async {
    try {
      await saveEmergencyContact(event.contact);
      final contacts = await getEmergencyContacts();
      emit(ContactsLoaded(contacts));
    } catch (e) {
      emit(const ContactsFailure('Failed to add contact.'));
    }
  }

  Future<void> _onAddMultiple(AddMultipleEmergencyContactsEvent event, Emitter<ContactsState> emit) async {
    try {
      for (final c in event.contacts) {
        await saveEmergencyContact(c);
      }
      final contacts = await getEmergencyContacts();
      emit(ContactsLoaded(contacts));
    } catch (e) {
      emit(const ContactsFailure('Failed to save contacts.'));
    }
  }

  Future<void> _onDelete(DeleteEmergencyContactEvent event, Emitter<ContactsState> emit) async {
    try {
      await deleteEmergencyContact(event.id);
      final contacts = await getEmergencyContacts();
      emit(ContactsLoaded(contacts));
    } catch (e) {
      emit(const ContactsFailure('Failed to delete contact.'));
    }
  }
}
