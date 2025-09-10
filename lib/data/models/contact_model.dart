import 'package:hive/hive.dart';
import 'package:guardwell/domain/entities/emergency_contact.dart';

part 'contact_model.g.dart';

@HiveType(typeId: 0)
class ContactModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String phoneNumber;

  ContactModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
  });

  factory ContactModel.fromEntity(EmergencyContact entity) {
    return ContactModel(
      id: entity.id,
      name: entity.name,
      phoneNumber: entity.phoneNumber,
    );
  }

  EmergencyContact toEntity() {
    return EmergencyContact(id: id, name: name, phoneNumber: phoneNumber);
  }
}
