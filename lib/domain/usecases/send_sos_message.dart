import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:guardwell/domain/entities/emergency_contact.dart';

class SendSosMessage {
  Future<void> call(List<EmergencyContact> contacts, Position location) async {
    final message =
        "🚨 EMERGENCY ALERT! 🚨\n\n"
        "I need immediate help! My current location is:\n\n"
        "📍 Latitude: ${location.latitude}\n"
        "📍 Longitude: ${location.longitude}\n\n"
        "Google Maps: https://maps.google.com/?q=${location.latitude},${location.longitude}\n\n"
        "Please contact me or emergency services immediately!";

    // for (final contact in contacts) {
    //   final encodedMessage = Uri.encodeComponent(message);
    //   final whatsappUrl =
    //       "https://wa.me/${contact.phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '')}?text=$encodedMessage";

    //   final uri = Uri.parse(whatsappUrl);
    //   if (await canLaunchUrl(uri)) {
    //     await launchUrl(uri, mode: LaunchMode.externalApplication);
    //   }
    // }
    final phones = contacts.map((c) => c.phoneNumber).join(',');
    final smsUrl = Uri.parse(
      'sms:$phones?body=${Uri.encodeComponent(message)}',
    );
    if (await canLaunchUrl(smsUrl)) {
      await launchUrl(smsUrl);
    }
  }
}
