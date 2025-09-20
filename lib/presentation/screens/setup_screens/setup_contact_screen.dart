import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as fc;
import 'package:guardwell/core/constants.dart';
import 'package:guardwell/domain/entities/emergency_contact.dart';
import 'package:guardwell/presentation/bloc/contacts/contacts_bloc.dart';
import 'package:guardwell/presentation/bloc/contacts/contacts_event.dart';
import 'package:guardwell/presentation/bloc/contacts/contacts_state.dart';
import 'package:guardwell/presentation/bloc/system_contacts/system_contacts_cubit.dart';
import 'package:guardwell/presentation/bloc/system_contacts/system_contacts_state.dart';
import 'package:guardwell/presentation/screens/home_screen.dart';
import 'package:guardwell/presentation/widgets/contact_selector.dart';

class SetupContactScreen extends StatefulWidget {
  const SetupContactScreen({super.key});

  @override
  State<SetupContactScreen> createState() => _SetupContactScreenState();
}

class _SetupContactScreenState extends State<SetupContactScreen> {
  List<fc.Contact> _systemContacts = [];
  final List<EmergencyContact> _selectedContacts = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    context.read<SystemContactsCubit>().load();
  }

  void _addContact(fc.Contact contact) {
    if (_selectedContacts.length >= 5) {
      _showErrorDialog('add_contact_warning'.tr());
      return;
    }

    final phoneNumber = contact.phones.isNotEmpty
        ? contact.phones.first.number
        : '';

    final emergencyContact = EmergencyContact(
      id: phoneNumber,
      name: contact.displayName.isNotEmpty ? contact.displayName : 'unkown'.tr(),
      phoneNumber: phoneNumber,
    );

    setState(() => _selectedContacts.add(emergencyContact));
  }

  void _removeContact(int index) =>
      setState(() => _selectedContacts.removeAt(index));

  void _saveAndContinue() {
    if (_selectedContacts.isEmpty) {
      _showErrorDialog('Please select at least one emergency contact.');
      return;
    }
    setState(() => _isLoading = true);
    context.read<ContactsBloc>().add(
      AddMultipleEmergencyContactsEvent(_selectedContacts),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:  Text('error'.tr()),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child:  Text('ok'.tr()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ContactsBloc, ContactsState>(
      listener: (context, state) {
        if (_isLoading && state is ContactsLoaded) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
        if (_isLoading && state is ContactsFailure) {
          setState(() => _isLoading = false);
          _showErrorDialog('Failed to save contacts. Please try again.');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title:  Text(
            'setup_contacts'.tr(),
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                children: [
                  Icon(
                    Icons.security,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  Text(
                    'setup_contacts_sub'.tr(),
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.smallPadding),
                  Text(
                    'setup_contacts_choise'.tr(),
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  if (_selectedContacts.isNotEmpty) ...[
                    const SizedBox(height: AppConstants.defaultPadding),
                    Text(
                      '${'setup_contatcs_select'.tr()} (${_selectedContacts.length}/5)',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppConstants.smallPadding),
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _selectedContacts.length,
                        itemBuilder: (context, index) {
                          final contact = _selectedContacts[index];
                          return Container(
                            margin: const EdgeInsets.only(right: 8),
                            child: Chip(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.green.shade100),
                                borderRadius: BorderRadiusGeometry.all(
                                  Radius.circular(25),
                                ),
                              ),
                              label: Text(
                                contact.name,
                                style: TextStyle(color: Colors.green.shade800),
                              ),
                              deleteIcon: Icon(
                                Icons.close,
                                size: 18,
                                color: Colors.green.shade800,
                              ),
                              onDeleted: () => _removeContact(index),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<SystemContactsCubit, SystemContactsState>(
                builder: (context, state) {
                  if (state is SystemContactsLoading ||
                      state is SystemContactsInitial) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is SystemContactsFailure) {
                    return Center(child: Text(state.message));
                  }
                  if (state is SystemContactsLoaded) {
                    _systemContacts = state.contacts;
                    return ContactSelector(
                      contacts: _systemContacts,
                      onContactSelected: _addContact,
                      selectedContactIds: _selectedContacts
                          .map((c) => c.id)
                          .toList(),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.green.shade100),
            ),
            onPressed: _selectedContacts.isEmpty || _isLoading
                ? null
                : _saveAndContinue,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    'continue'.tr(),
                    style: TextStyle(
                      color: Colors.green.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
