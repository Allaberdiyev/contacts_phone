import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:contacts_phone/app/theme.dart';
import 'package:contacts_phone/features/contacts/presentation/contacts/pages/conatact_details_page.dart';
import '../../../data/models/contacts_model.dart';

class FavoriteTileItem extends StatelessWidget {
  final ContactsModel contact;
  final bool isDark;
  final bool editing;
  final VoidCallback onRemove;

  const FavoriteTileItem({
    super.key,
    required this.contact,
    required this.isDark,
    required this.editing,
    required this.onRemove,
  });

  String get initials {
    final f = contact.firstName.trim();
    final l = contact.lastName.trim();
    return '${f.isNotEmpty ? f[0] : ''}${l.isNotEmpty ? l[0] : ''}'
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);

    final name = '${contact.firstName} ${contact.lastName}'.trim();
    final title = name.isEmpty ? contact.phoneNumber : name;

    final titleColor = p.text;
    final subColor = p.text2;

    final removeBg = isDark ? p.surface2 : p.surface;
    final removeBorder = p.keypadBorder;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ContactDetailsPage(contact: contact),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      ContactDetailsTheme.backgroundColors[0],
                      ContactDetailsTheme.backgroundColors[3],
                    ],
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  initials.isEmpty ? ' ' : initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.phone_fill,
                          size: 14,
                          color: subColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'mobile',
                          style: TextStyle(
                            color: subColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              if (editing)
                InkWell(
                  onTap: onRemove,
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: removeBg,
                      border: Border.all(color: removeBorder, width: 1),
                    ),
                    child: Icon(
                      CupertinoIcons.minus,
                      color: p.danger,
                      size: 18,
                    ),
                  ),
                )
              else
                Icon(
                  CupertinoIcons.info_circle,
                  color: p.primary,
                  size: 28,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
