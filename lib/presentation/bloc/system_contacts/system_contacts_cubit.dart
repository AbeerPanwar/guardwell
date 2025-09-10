import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guardwell/domain/repositories/contact_repository.dart';
import 'package:guardwell/presentation/bloc/system_contacts/system_contacts_state.dart';

class SystemContactsCubit extends Cubit<SystemContactsState> {
  final ContactRepository repository;
  SystemContactsCubit({required this.repository}) : super(const SystemContactsInitial());

  Future<void> load() async {
    emit(const SystemContactsLoading());
    try {
      final contacts = await repository.getSystemContacts();
      emit(SystemContactsLoaded(contacts));
    } catch (e) {
      emit(const SystemContactsFailure('Failed to load contacts. Please check permissions.'));
    }
  }
}
