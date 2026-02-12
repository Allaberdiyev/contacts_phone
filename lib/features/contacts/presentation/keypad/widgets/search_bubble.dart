import 'dart:ui';
import 'package:contacts_phone/app/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:contacts_phone/features/contacts/data/models/contacts_model.dart';
import '../utils/phone_format.dart';

class SearchBubble extends StatelessWidget {
  final ContactsModel contact;
  final int total;
  final VoidCallback onTap;

  const SearchBubble({
    super.key,
    required this.contact,
    required this.total,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);

    final name = ('${contact.firstName} ${contact.lastName}').trim();
    final title = name.isEmpty ? contact.phoneNumber : name;
    final phone = PhoneFormat.formatUzWithCountry(contact.phoneNumber);

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: p.searchBubbleBg,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: p.searchBubbleBorder),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: p.searchBubbleAvatarBg,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        CupertinoIcons.person_fill,
                        size: 16,
                        color: p.searchBubbleTitle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: p.searchBubbleTitle,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              phone,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: p.searchBubbleSub,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (total > 1) ...[
                  const SizedBox(height: 12),
                  Divider(height: 1, color: p.searchBubbleDivider),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.search,
                        size: 18,
                        color: p.searchBubbleSub,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'More Results',
                        style: TextStyle(
                          color: p.searchBubbleSub,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
