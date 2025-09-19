// import 'dart:async';
// import 'dart:ui';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:guardwell/data/repositories/contact_repository_impl.dart';
// import 'package:guardwell/data/services/contact_service.dart';
// import 'package:guardwell/data/services/location_service.dart';
// import 'package:guardwell/domain/usecases/contacts/get_emergency_contacts.dart';
// import 'package:guardwell/domain/usecases/send_sos_message.dart';

// class BackgroundService {
//   static Future<void> initialize({
//     required String backendUrl,
//     required String token,
//   }) async {
//     final service = FlutterBackgroundService();

//     await service.configure(
//       androidConfiguration: AndroidConfiguration(
//         onStart: onStart,
//         isForegroundMode: true,
//         autoStart: true,
//         notificationChannelId: 'guardwell_background',
//         initialNotificationTitle: 'GuardWell Running',
//         initialNotificationContent: 'Background service active',
//       ),
//       iosConfiguration: IosConfiguration(
//         autoStart: true,
//         onForeground: onStart,
//         onBackground: onIosBackground,
//       ),
//     );

//     await service.startService();
//     service.invoke("setData", {"backendUrl": backendUrl, "token": token});
//   }
// }

// /// iOS background handler
// @pragma('vm:entry-point')
// Future<bool> onIosBackground(ServiceInstance service) async {
//   return true;
// }

// /// Main background runner
// @pragma('vm:entry-point')
// Future<void> onStart(ServiceInstance service) async {
//   DartPluginRegistrant.ensureInitialized();
//   print('stoppppppppppppppppppp');
//   if (service is AndroidServiceInstance) {
//     service.setAsForegroundService();
//     print('doneeeeeeeeeeeeeeeeeeeee');
//     service.setForegroundNotificationInfo(
//       title: "Guardwell",
//       content: "Background service active",
//     );
//   }

//   service.on("setData").listen((event) {
//     if (event != null) {
//       final backendUrl = event["backendUrl"];
//       final token = event["token"];

//       final locationService = LocationService(
//         baseUrl: backendUrl,
//         token: token,
//       );

//       final getEmergencyContacts = GetEmergencyContacts(
//         ContactRepositoryImpl(ContactService()),
//       );
//       final sendSosMessage = SendSosMessage();

//       // ✅ Example: stream location every 10 seconds
//       Timer.periodic(const Duration(seconds: 10), (timer) async {
//         try {
//           final pos = await Geolocator.getCurrentPosition(
//             desiredAccuracy: LocationAccuracy.high,
//           );
//           await locationService.updateSos(pos);
//           print("📍 Updated location: ${pos.latitude}, ${pos.longitude}");
//         } catch (e) {
//           print("❌ Failed to get location in background: $e");
//         }
//       });

//       // ✅ Example: SOS trigger
//       service.on("sendSOS").listen((event) async {
//         try {
//           final pos = await Geolocator.getCurrentPosition(
//             desiredAccuracy: LocationAccuracy.high,
//           );
//           await locationService.sendSos(pos);
//           final contacts = await getEmergencyContacts();
//           await sendSosMessage(contacts, pos);
//           print("🚨 SOS sent in background!");
//         } catch (e) {
//           print("❌ Failed to send SOS in background: $e");
//         }
//       });
//     }
//   });
// }
