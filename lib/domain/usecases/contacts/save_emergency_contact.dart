import 'package:guardwell/domain/entities/emergency_contact.dart';
import 'package:guardwell/domain/repositories/contact_repository.dart';

class SaveEmergencyContact {
  final ContactRepository repository;

  SaveEmergencyContact(this.repository);

  Future<void> call(EmergencyContact contact) => repository.saveEmergencyContact(contact);
}