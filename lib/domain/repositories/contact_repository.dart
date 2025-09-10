// domain/repositories/contact_repository.dart
import 'package:flutter_contacts/flutter_contacts.dart' as fc;
import '../entities/emergency_contact.dart';

abstract class ContactRepository {
  Future<List<EmergencyContact>> getEmergencyContacts();
  Future<void> saveEmergencyContact(EmergencyContact contact);
  Future<void> deleteEmergencyContact(String id);
  Future<List<fc.Contact>> getSystemContacts(); // prefixed type
  Future<bool> hasEmergencyContactsConfigured();
}
