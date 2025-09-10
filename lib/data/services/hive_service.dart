import 'package:guardwell/data/models/contact_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String emergencyContactsBox = 'emergency_contacts';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ContactModelAdapter());
    await Hive.openBox<ContactModel>(emergencyContactsBox);
  }

  static Box<ContactModel> getEmergencyContactsBox() {
    return Hive.box<ContactModel>(emergencyContactsBox);
  }
}
