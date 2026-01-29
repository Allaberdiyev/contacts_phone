import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_phone/core/utils/colors/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Material(
          color: isDark ? AppColors.dark : AppColors.white,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 6,
            ),
            leading: CircleAvatar(
              radius: 22,
              backgroundImage: contact.imageUrl.isNotEmpty
                  ? NetworkImage(contact.imageUrl)
                  : null,
              child: contact.imageUrl.isEmpty
                  ? Text(
                      initials.isEmpty ? '?' : initials,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.white : AppColors.dark,
                      ),
                    )
                  : null,
            ),
            title: Text(
              '${contact.firstName} ${contact.lastName}',
              style: TextStyle(
                fontSize: 16,
                color: isDark ? AppColors.white : AppColors.dark,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              contact.phoneNumber,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.white : AppColors.dark,
              ),
            ),
            trailing: CircleAvatar(
              backgroundColor: isDark
                  ? AppColors.darkgrey
                  : AppColors.whitegrey,
              child: IconButton(
                icon: Icon(Icons.phone, color: AppColors.blue),
                onPressed: () async {
                  final phone = contact.phoneNumber.replaceAll(
                    RegExp(r'[^0-9+]'),
                    '',
                  );
                  final uri = Uri(scheme: 'tel', path: phone);

                  final ok = await launchUrl(
                    uri,
                    mode: LaunchMode.externalApplication,
                  );
                  if (!ok && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Nomer ochilmadi")),
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
