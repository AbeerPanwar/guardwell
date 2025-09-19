import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:guardwell/domain/usecases/contacts/get_emergency_contacts.dart';
import 'package:guardwell/domain/usecases/send_sos_message.dart';
import 'package:guardwell/presentation/bloc/location/location_bloc.dart';
import 'package:guardwell/presentation/bloc/location/location_event.dart';
import 'package:guardwell/presentation/bloc/sos/sos_state.dart';

class SosCubit extends Cubit<SosState> {
  final GetEmergencyContacts getEmergencyContacts;
  final SendSosMessage sendSosMessage;
  final LocationBloc locationBloc;
  SosCubit(
    this.locationBloc, {
    required this.getEmergencyContacts,
    required this.sendSosMessage,
  }) : super(const SosIdle());

  Future<void> send(Position position) async {
    emit(const SosSending());
    try {
      final contacts = await getEmergencyContacts();
      if (contacts.isEmpty) {
        emit(
          const SosFailure(
            'No emergency contacts found. Please add emergency contacts first.',
          ),
        );
        return;
      }
      await sendSosMessage(contacts, position);
      emit(SosSuccess(contacts.length));
      emit(const SosIdle());
    } catch (e) {
      emit(const SosFailure('Failed to send SOS alert. Please try again.'));
    } finally {
      emit(const SosIdle());
    }
  }

  void sendSos() async {
    try {
      emit(SosSending());
      locationBloc.add(StartSosLocationEvent()); // start SOS location streaming
      emit(SosActive());
    } catch (e) {
      emit(SosFailure("Failed to start SOS: $e"));
    }
  }

  void stopSos() {
    try {
      locationBloc.add(StopSosLocationEvent()); // stop SOS location streaming
      emit(SosStopped());
    } catch (e) {
      emit(SosFailure("Failed to stop SOS: $e"));
    }
  }

  // Handles both: SMS to contacts + backend call
  Future<void> sendFullSos(Position position) async {
    emit(const SosSending());
    try {
      // 1. Send to backend
      locationBloc.add(StartSosLocationEvent());

      // 2. Send to contacts
      final contacts = await getEmergencyContacts();
      if (contacts.isEmpty) {
        emit(
          const SosFailure(
            'No emergency contacts found. Please add emergency contacts first.',
          ),
        );
        return;
      }
      await sendSosMessage(contacts, position);

      emit(SosSuccess(contacts.length));
      emit(SosActive());
    } catch (e) {
      emit(SosFailure("Failed to send full SOS: $e"));
    }
  }
}
