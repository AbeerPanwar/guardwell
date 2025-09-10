import 'package:guardwell/domain/repositories/contact_repository.dart';

class DeleteEmergencyContact {
  final ContactRepository repository;

  DeleteEmergencyContact(this.repository);

  Future<void> call(String id) => repository.deleteEmergencyContact(id);
}