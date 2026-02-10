import 'dart:ui';

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
              color: Colors.white.withOpacity(0.09),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: Colors.white.withOpacity(0.06)),
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
                        color: Colors.white.withOpacity(0.10),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        CupertinoIcons.person_fill,
                        size: 16,
                        color: Colors.white.withOpacity(0.9),
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
                                color: Colors.white.withOpacity(0.92),
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
                                color: Colors.white.withOpacity(0.55),
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
                  Divider(height: 1, color: Colors.white.withOpacity(0.10)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.search,
                        size: 18,
                        color: Colors.white.withOpacity(0.65),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${total - 1} More Results',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.65),
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
