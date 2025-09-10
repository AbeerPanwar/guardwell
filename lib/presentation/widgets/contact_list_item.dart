import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:guardwell/core/constants.dart';
import 'package:guardwell/domain/entities/emergency_contact.dart';

class ContactListItem extends StatelessWidget {
  final EmergencyContact contact;
  final VoidCallback? onDelete;

  const ContactListItem({super.key, required this.contact, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: AppConstants.smallPadding,
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.green.shade100,
          child: Text(
            contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
            style: TextStyle(
              color: Colors.green.shade800,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          contact.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          contact.phoneNumber,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        trailing: onDelete != null
            ? GestureDetector(
                onTap: onDelete,
                child: Text(
                  'remove'.tr(),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
