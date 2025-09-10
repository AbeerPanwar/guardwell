import 'package:flutter_contacts/flutter_contacts.dart' as fc;
import 'package:guardwell/data/models/contact_model.dart';
import 'package:guardwell/data/services/contact_service.dart';
import 'package:guardwell/data/services/hive_service.dart';
import 'package:guardwell/domain/entities/emergency_contact.dart';
import 'package:guardwell/domain/repositories/contact_repository.dart';

class ContactRepositoryImpl implements ContactRepository {
  final ContactService contactService;

  ContactRepositoryImpl(this.contactService);

  @override
  Future<List<EmergencyContact>> getEmergencyContacts() async {
    final box = HiveService.getEmergencyContactsBox();
    return box.values.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> saveEmergencyContact(EmergencyContact contact) async {
    final box = HiveService.getEmergencyContactsBox();
    final model = ContactModel.fromEntity(contact);
    await box.put(contact.id, model);
  }

  @override
  Future<void> deleteEmergencyContact(String id) async {
    final box = HiveService.getEmergencyContactsBox();
    await box.delete(id);
  }

  // Note the prefixed type here
  @override
  Future<List<fc.Contact>> getSystemContacts() =>
      contactService.getSystemContacts();

  @override
  Future<bool> hasEmergencyContactsConfigured() async {
    final box = HiveService.getEmergencyContactsBox();
    return box.isNotEmpty;
  }
}
