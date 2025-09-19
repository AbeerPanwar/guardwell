import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as fc;
import 'package:guardwell/core/constants.dart';
import 'package:guardwell/data/repositories/contact_repository_impl.dart';
import 'package:guardwell/data/services/contact_service.dart';
import 'package:guardwell/domain/entities/emergency_contact.dart';
import 'package:guardwell/domain/usecases/contacts/delete_emergency_contact.dart';
import 'package:guardwell/domain/usecases/contacts/get_emergency_contacts.dart';
import 'package:guardwell/domain/usecases/contacts/save_emergency_contact.dart';
import 'package:guardwell/presentation/widgets/contact_list_item.dart';
import 'package:guardwell/presentation/widgets/contact_selector.dart';

class ContactManagementScreen extends StatefulWidget {
  const ContactManagementScreen({super.key});

  @override
  State<ContactManagementScreen> createState() =>
      _ContactManagementScreenState();
}

class _ContactManagementScreenState extends State<ContactManagementScreen> {
  final ContactService _contactService = ContactService();
  late final GetEmergencyContacts _getEmergencyContacts;
  late final SaveEmergencyContact _saveEmergencyContact;
  late final DeleteEmergencyContact _deleteEmergencyContact;

  List<EmergencyContact> _emergencyContacts = [];
  List<fc.Contact> _systemContacts = [];
  bool _isLoading = true;
  bool _isAddingContact = false;

  @override
  void initState() {
    super.initState();
    final repository = ContactRepositoryImpl(_contactService);
    _getEmergencyContacts = GetEmergencyContacts(repository);
    _saveEmergencyContact = SaveEmergencyContact(repository);
    _deleteEmergencyContact = DeleteEmergencyContact(repository);
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final emergencyContacts = await _getEmergencyContacts();
      if (mounted) {
        setState(() {
          _emergencyContacts = emergencyContacts;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog('load_data_error'.tr());
      }
    }
  }

  Future<void> _loadSystemContacts() async {
    try {
      final contacts = await _contactService.getSystemContacts();
      setState(() {
        _systemContacts = contacts;
      });
    } catch (e) {
      _showErrorDialog('load_system_error'.tr());
    }
  }

  Future<void> _deleteContact(String id) async {
    try {
      await _deleteEmergencyContact(id);
      setState(() {
        _emergencyContacts.removeWhere((contact) => contact.id == id);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('delete_contact'.tr())),
        );
      }
    } catch (e) {
      _showErrorDialog('Failed to delete contact.');
    }
  }

  Future<void> _addContact(fc.Contact contact) async {
    if (_emergencyContacts.length >= 5) {
      _showErrorDialog('add_contact_warning'.tr());
      return;
    }

    final phoneNumber = contact.phones.isNotEmpty
        ? contact.phones.first.number
        : '';
    final emergencyContact = EmergencyContact(
      id: phoneNumber,
      name: contact.displayName,
      phoneNumber: phoneNumber,
    );

    try {
      await _saveEmergencyContact(emergencyContact);
      setState(() {
        _emergencyContacts.add(emergencyContact);
        _isAddingContact = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('add_contact'.tr())),
        );
      }
    } catch (e) {
      _showErrorDialog('add_contact_error'.tr());
    }
  }

  void _showAddContactDialog() async {
    setState(() {
      _isAddingContact = true;
    });

    await _loadSystemContacts();

    if (mounted) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade500,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: 3,
                    width: 35,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 16, right: 16,top: 8,),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'emergency_contact'.tr(),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() {
                            _isAddingContact = false;
                          });
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ContactSelector(
                  contacts: _systemContacts,
                  onContactSelected: (contact) {
                    Navigator.of(context).pop();
                    _addContact(contact);
                  },
                  selectedContactIds: _emergencyContacts
                      .map((c) => c.id)
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  void _showDeleteConfirmation(EmergencyContact contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('delete_contact_alert'.tr()),
        content: Text(
          'delete_contact_alert_sub'.tr(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('cancel'.tr()),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteContact(contact.id);
            },
            child: Text(
              'delete'.tr(),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('error'.tr()),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('ok'.tr()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.all(Radius.circular(10)),
            ),
            elevation: 0.5,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 22),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'contact_sub'.tr(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _emergencyContacts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.contacts, size: 64, color: Colors.green.shade700),
                  const SizedBox(height: AppConstants.defaultPadding),
                  Text(
                    'no_contact'.tr(),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: AppConstants.smallPadding),
                  Text(
                    'no_contact_sub'.tr(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : Container(
              margin: EdgeInsets.all(8),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  vertical: AppConstants.smallPadding,
                ),
                itemCount: _emergencyContacts.length,
                itemBuilder: (context, index) {
                  final contact = _emergencyContacts[index];
                  return ContactListItem(
                    contact: contact,
                    onDelete: () => _showDeleteConfirmation(contact),
                  );
                },
              ),
            ),
      floatingActionButton: _emergencyContacts.length < 5
          ? FloatingActionButton(
              backgroundColor: Colors.green.shade100,
              onPressed: _isAddingContact ? null : _showAddContactDialog,
              child: _isAddingContact
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(Icons.add, color: Colors.green.shade800),
            )
          : null,
    );
  }
}
