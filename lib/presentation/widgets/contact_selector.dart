import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as fc;
import 'package:guardwell/core/constants.dart';

class ContactSelector extends StatefulWidget {
  final List<fc.Contact> contacts;
  final Function(fc.Contact) onContactSelected;
  final List<String> selectedContactIds;

  const ContactSelector({
    super.key,
    required this.contacts,
    required this.onContactSelected,
    required this.selectedContactIds,
  });

  @override
  State<ContactSelector> createState() => _ContactSelectorState();
}

class _ContactSelectorState extends State<ContactSelector> {
  // ignore: unused_field
  String _searchQuery = '';
  late List<fc.Contact> _filteredContacts;

  @override
  void initState() {
    super.initState();
    _filteredContacts = widget.contacts;
  }

  void _filterContacts(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredContacts = widget.contacts;
      } else {
        _filteredContacts = widget.contacts.where((contact) {
          final name = contact.displayName.toLowerCase();
          return name.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  String _getPhoneNumber(fc.Contact contact) {
    return contact.phones.isNotEmpty ? contact.phones.first.number : '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: TextField(
            onChanged: _filterContacts,
            cursorColor: Colors.green.shade100,
            decoration: InputDecoration(
              hintText: 'search_contacts'.tr(),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 4,),
                child: Card(
                  elevation: 0,
                  color: Colors.green.shade100,
                  child: Icon(Icons.search, color: Colors.green.shade800),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.green.shade800, width: 1.5,)
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _filteredContacts.length,
            itemBuilder: (context, index) {
              final contact = _filteredContacts[index];
              final phoneNumber = _getPhoneNumber(contact);
              final isSelected = widget.selectedContactIds.contains(
                phoneNumber,
              );

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: isSelected
                      ? Colors.green.shade100
                      : Colors.grey.shade300,
                  child: Text(
                    contact.displayName.isNotEmpty
                        ? contact.displayName[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      color: isSelected
                          ? Colors.green.shade800
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  contact.displayName.isNotEmpty
                      ? contact.displayName
                      : 'unkown'.tr(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Text(
                  phoneNumber,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                trailing: isSelected
                    ? Icon(
                        Icons.check_circle,
                        color: Colors.green.shade800,
                      )
                    : null,
                onTap: phoneNumber.isNotEmpty && !isSelected
                    ? () => widget.onContactSelected(contact)
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }
}
