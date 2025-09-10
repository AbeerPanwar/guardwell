import 'package:flutter_contacts/flutter_contacts.dart' as fc;
import 'package:permission_handler/permission_handler.dart';

class ContactService {
  Future<List<fc.Contact>> getSystemContacts() async {
    final granted = await requestContactPermission();
    if (!granted) throw Exception('Contact permission denied');

    final contacts = await fc.FlutterContacts.getContacts(
      withProperties: true, // needed for phone numbers
      withPhoto: false,
    );

    return contacts
        .where((c) =>
            c.phones.isNotEmpty &&
            c.displayName.trim().isNotEmpty)
        .toList();
  }

  Future<bool> hasContactPermission() async {
    return Permission.contacts.status.isGranted;
  }

  Future<bool> requestContactPermission() async {
    final status = await Permission.contacts.request();
    if (status.isGranted) return true;
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
    return false;
  }
}
