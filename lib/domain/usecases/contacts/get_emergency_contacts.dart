import 'package:guardwell/domain/entities/emergency_contact.dart';
import 'package:guardwell/domain/repositories/contact_repository.dart';

class GetEmergencyContacts {
  final ContactRepository repository;

  GetEmergencyContacts(this.repository);

  Future<List<EmergencyContact>> call() => repository.getEmergencyContacts();
}