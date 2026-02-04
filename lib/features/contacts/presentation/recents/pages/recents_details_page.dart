import 'package:contacts_phone/core/utils/colors/app_colors.dart';
import 'package:contacts_phone/features/contacts/data/models/contacts_model.dart';
import 'package:contacts_phone/features/contacts/presentation/contacts/widgets/add_contact_sheet.dart';
import 'package:contacts_phone/features/contacts/presentation/contacts/widgets/avatar.dart';
import 'package:contacts_phone/features/contacts/presentation/contacts/widgets/background.dart';
import 'package:contacts_phone/features/contacts/presentation/contacts/widgets/blur_card.dart';
import 'package:contacts_phone/features/contacts/presentation/contacts/widgets/contact_header_delegate.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RecentsDetailsPage extends StatelessWidget {
  final ContactsModel contact;
  const RecentsDetailsPage({super.key, required this.contact});

  String get name {
    final full = '${contact.firstName} ${contact.lastName}'.trim();
    return full.isEmpty ? "No name" : full;
  }

  String get initials {
    final f = contact.firstName.trim();
    final l = contact.lastName.trim();
    return '${f.isNotEmpty ? f[0] : ''}${l.isNotEmpty ? l[0] : ''}'
        .toUpperCase();
  }

  Future<void> openUri(BuildContext context, String uri) async {
    final ok = await launchUrl(
      Uri.parse(uri),
      mode: LaunchMode.externalApplication,
    );
    if (!ok) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Ochilmadi: $uri")));
    }
  }

  void openEditSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddContactSheet(contact: contact),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          const Positioned.fill(child: Background()),
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // SliverToBoxAdapter(child: SizedBox(height: 50)),
              SliverPersistentHeader(
                pinned: true,
                delegate: ContactHeaderDelegate(
                  onSegmentChanged: (value) {},
                  segment: 12,
                  contact: contact,
                  name: name,
                  initials: initials,

                  onBack: () => Navigator.pop(context),
                  onEdit: () => openEditSheet(context),

                  onSms: () => openUri(context, 'sms:${contact.phoneNumber}'),
                  onCall: () => openUri(context, 'tel:${contact.phoneNumber}'),
                  onVideo: () => openUri(context, 'tel:${contact.phoneNumber}'),
                  onMail: () => ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text("Email yo‘q"))),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 28),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    BlurCard(
                      child: Row(
                        children: [
                          Avatar(
                            size: 44,
                            initials: initials,
                            imageUrl: contact.imageUrl,
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              "Contact Photo & Poster",
                              style: ContactDetailsTheme.cardTitle,
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right_rounded,
                            color: Colors.white38,
                            size: 26,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    BlurCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "mobile",
                            style: ContactDetailsTheme.label,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            contact.phoneNumber,
                            style: ContactDetailsTheme.cardValue,
                          ),
                          const SizedBox(height: 12),
                          const Divider(height: 1, color: Colors.white12),
                          const SizedBox(height: 12),
                          const Text(
                            "Notes",
                            style: ContactDetailsTheme.cardTitle,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    BlurCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Send Message",
                            style: ContactDetailsTheme.cardTitle,
                          ),
                          SizedBox(height: 12),
                          Divider(height: 1, color: Colors.white12),
                          SizedBox(height: 12),
                          Text(
                            "Share Contact",
                            style: ContactDetailsTheme.cardTitle,
                          ),
                          SizedBox(height: 12),
                          Divider(height: 1, color: Colors.white12),
                          SizedBox(height: 12),
                          Text(
                            "Add to Favorites",
                            style: ContactDetailsTheme.cardTitle,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    BlurCard(
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Add to Emergency Contacts",
                          style: ContactDetailsTheme.cardTitle,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    BlurCard(
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          " Contact",
                          style: ContactDetailsTheme.cardTitle,
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
