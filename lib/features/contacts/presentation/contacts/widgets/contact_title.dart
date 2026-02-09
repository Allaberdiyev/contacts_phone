import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_phone/core/utils/colors/app_colors.dart';
import 'package:contacts_phone/features/contacts/presentation/contacts/pages/conatact_details_page.dart';
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
    final fullName = '${contact.firstName} ${contact.lastName}'.trim();
    final hasName = fullName.isNotEmpty;

    const tileBg = Color(0xFF000000);

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
            color: tileBg,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 6,
              ),

              leading: IosAvatar(
                size: 44,
                initials: initials,
                imageUrl: contact.imageUrl,
              ),

              title: Text(
                hasName ? fullName : contact.phoneNumber,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
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

class IosAvatar extends StatelessWidget {
  final double size;
  final String initials;
  final String imageUrl;

  const IosAvatar({
    super.key,
    required this.size,
    required this.initials,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          imageUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _fallback(),
        ),
      );
    }
    return _fallback();
  }

  Widget _fallback() {
    final color1 = ContactDetailsTheme.backgroundColors[1];
    final color2 = ContactDetailsTheme.backgroundColors[3];

    return SizedBox(
      width: size,
      height: size,
      child: ClipOval(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color1, color2],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(-0.55, -0.6),
                  radius: 1.1,
                  colors: [Colors.white.withOpacity(0.22), Colors.transparent],
                ),
              ),
            ),
            Center(
              child: Text(
                initials.isEmpty ? ' ' : initials,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: size * 0.36,
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
