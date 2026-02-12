import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_phone/app/theme.dart';
import 'package:contacts_phone/features/contacts/presentation/contacts/pages/conatact_details_page.dart';
import 'package:contacts_phone/features/contacts/presentation/contacts/widgets/avatar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/contacts_model.dart';
import '../bloc/contacts_bloc.dart';
import 'add_contact_sheet.dart';

class ContactTile extends StatelessWidget {
  final ContactsModel contact;

  const ContactTile({super.key, required this.contact});

  String get initials {
    final f = contact.firstName.trim();
    final l = contact.lastName.trim();
    return '${f.isNotEmpty ? f[0] : ''}${l.isNotEmpty ? l[0] : ''}'
        .toUpperCase();
  }

  void _openEditSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: context.read<ContactBloc>(),
        child: AddContactSheet(contact: contact),
      ),
    );
  }

  Future<void> _deleteContact() async {
    await FirebaseFirestore.instance
        .collection('contacts')
        .doc(contact.id)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);

    final fullName = '${contact.firstName} ${contact.lastName}'.trim();
    final hasName = fullName.isNotEmpty;

    return CupertinoContextMenu(
      actions: [
        CupertinoContextMenuAction(
          onPressed: () {
            Navigator.pop(context);
            _openEditSheet(context);
          },
          child: Text('edit'.tr()),
        ),
        CupertinoContextMenuAction(
          isDestructiveAction: true,
          onPressed: () async {
            Navigator.pop(context);
            await _deleteContact();
          },
          child: Text('delete'.tr()),
        ),
      ],
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ContactDetailsPage(contact: contact),
            ),
          );
        },
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Material(
            color: p.bg,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 6,
              ),
              leading: Avatar(
                size: 44,
                initials: initials,
                imageUrl: contact.imageUrl,
              ),
              title: Text(
                hasName ? fullName : contact.phoneNumber,
                style: TextStyle(
                  fontSize: 16,
                  color: p.text,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
