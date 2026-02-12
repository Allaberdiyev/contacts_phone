import 'package:contacts_phone/app/theme.dart';
import 'package:contacts_phone/features/contacts/data/models/contacts_model.dart';
import 'package:contacts_phone/features/contacts/presentation/contacts/widgets/add_contact_sheet.dart';
import 'package:contacts_phone/features/contacts/presentation/contacts/widgets/avatar.dart';
import 'package:contacts_phone/features/contacts/presentation/contacts/widgets/background.dart';
import 'package:contacts_phone/features/contacts/presentation/contacts/widgets/blur_card.dart';
import 'package:contacts_phone/features/contacts/presentation/contacts/widgets/contact_header_delegate.dart';
import 'package:contacts_phone/features/contacts/presentation/contacts/widgets/container_row.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactDetailsPage extends StatefulWidget {
  final ContactsModel contact;
  const ContactDetailsPage({super.key, required this.contact});

  @override
  State<ContactDetailsPage> createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  int segmentIndex = 0;

  String get name {
    final full = '${widget.contact.firstName} ${widget.contact.lastName}'
        .trim();
    return full.isEmpty ? "No name" : full;
  }

  String get initials {
    final f = widget.contact.firstName.trim();
    final l = widget.contact.lastName.trim();
    return '${f.isNotEmpty ? f[0] : ''}${l.isNotEmpty ? l[0] : ''}'
        .toUpperCase();
  }

  Future<void> openUri(String uri) async {
    await launchUrl(Uri.parse(uri), mode: LaunchMode.externalApplication);
  }

  void openEditSheet() {
    final p = AppColors.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: p.transparent,
      builder: (_) => AddContactSheet(contact: widget.contact),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);

    final dividerColor = p.searchBubbleDivider;
    final chevronColor = p.text3;
    final mutedStyle = TextStyle(
      color: p.text2,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );

    final cardTitleStyle = TextStyle(
      color: p.text,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );

    final labelStyle = TextStyle(
      color: p.text2,
      fontSize: 15,
      fontWeight: FontWeight.w600,
    );

    final valueStyle = TextStyle(
      color: p.text,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    );

    return Scaffold(
      backgroundColor: p.transparent,
      body: Stack(
        children: [
          const Positioned.fill(child: Background()),
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: ContactHeaderDelegate(
                  contact: widget.contact,
                  name: name,
                  initials: initials,
                  segment: segmentIndex,
                  onSegmentChanged: (v) => setState(() => segmentIndex = v),
                  onBack: () => Navigator.pop(context),
                  onEdit: openEditSheet,
                  onSms: () => openUri('sms:${widget.contact.phoneNumber}'),
                  onCall: () => openUri('tel:${widget.contact.phoneNumber}'),
                  onVideo: () => openUri('tel:${widget.contact.phoneNumber}'),
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
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text("Canceled Call", style: mutedStyle),
                              const Spacer(),
                              Text("Yesterday · 10:38", style: mutedStyle),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Divider(height: 1, color: dividerColor),
                          const SizedBox(height: 10),
                          ContainerRow(title: "Call History", onTap: () {}),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    BlurCard(
                      child: Row(
                        children: [
                          Avatar(
                            size: 44,
                            initials: initials,
                            imageUrl: widget.contact.imageUrl,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Contact Photo & Poster",
                              style: cardTitleStyle,
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: chevronColor,
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
                          Text("mobile", style: labelStyle),
                          const SizedBox(height: 6),
                          Text(widget.contact.phoneNumber, style: valueStyle),
                          const SizedBox(height: 12),
                          Divider(height: 1, color: dividerColor),
                          const SizedBox(height: 12),
                          Text("Notes", style: cardTitleStyle),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    BlurCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Send Message", style: cardTitleStyle),
                          const SizedBox(height: 12),
                          Divider(height: 1, color: dividerColor),
                          const SizedBox(height: 12),
                          Text("Share Contact", style: cardTitleStyle),
                          const SizedBox(height: 12),
                          Divider(height: 1, color: dividerColor),
                          const SizedBox(height: 12),
                          Text("Add to Favorites", style: cardTitleStyle),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    BlurCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Add to Emergency Contacts",
                            style: cardTitleStyle,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    BlurCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Block Contact", style: cardTitleStyle),
                        ],
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
