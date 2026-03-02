import 'dart:async';

import 'package:contacts_phone/app/theme.dart';
import 'package:contacts_phone/features/contacts/data/models/contacts_model.dart';
import 'package:contacts_phone/features/contacts/data/repositories/contacts_repositorie.dart';
import 'package:contacts_phone/features/contacts/presentation/contacts/bloc/contacts_bloc.dart';
import 'package:contacts_phone/features/contacts/presentation/contacts/widgets/add_contact_sheet.dart';
import 'package:contacts_phone/features/contacts/presentation/contacts/widgets/avatar.dart';
import 'package:contacts_phone/features/contacts/presentation/contacts/widgets/background.dart';
import 'package:contacts_phone/features/contacts/presentation/contacts/widgets/blur_card.dart';
import 'package:contacts_phone/features/contacts/presentation/contacts/widgets/contact_header_delegate.dart';
import 'package:contacts_phone/features/contacts/presentation/favorites/widget/save_shared_pref_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactDetailsPage extends StatefulWidget {
  final ContactsModel contact;
  const ContactDetailsPage({super.key, required this.contact});

  @override
  State<ContactDetailsPage> createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  int segmentIndex = 0;

  late final TextEditingController _notesCtrl;
  bool _isFavorite = false;

  Timer? _notesDebounce;

  String get name {
    final full = '${widget.contact.firstName} ${widget.contact.lastName}'
        .trim();
    return full.isEmpty ? widget.contact.phoneNumber : full;
  }

  String get initials {
    final f = widget.contact.firstName.trim();
    final l = widget.contact.lastName.trim();
    return '${f.isNotEmpty ? f[0] : ''}${l.isNotEmpty ? l[0] : ''}'
        .toUpperCase();
  }

  String get phone => widget.contact.phoneNumber;
  String get _notesKey => 'contact_notes_${widget.contact.id}';

  @override
  void initState() {
    super.initState();
    _notesCtrl = TextEditingController();
    _loadLocalState();
  }

  @override
  void dispose() {
    _notesDebounce?.cancel();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadLocalState() async {
    final fav = await SaveSharedPrefWidget.isFav(widget.contact.id);

    final prefs = await SharedPreferences.getInstance();
    final notes = prefs.getString(_notesKey) ?? '';

    if (!mounted) return;
    setState(() {
      _isFavorite = fav;
      _notesCtrl.text = notes;
    });
  }

  Future<void> _toggleFavorite() async {
    await SaveSharedPrefWidget.toggle(widget.contact.id);
    final fav = await SaveSharedPrefWidget.isFav(widget.contact.id);

    if (!mounted) return;
    setState(() => _isFavorite = fav);
  }

  void _onNotesChanged(String v) {
    _notesDebounce?.cancel();
    _notesDebounce = Timer(const Duration(milliseconds: 350), () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_notesKey, v.trimRight());
    });
  }

  Future<void> openUri(BuildContext context, String uri) async {
    final ok = await launchUrl(
      Uri.parse(uri),
      mode: LaunchMode.externalApplication,
    );
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('cant_open'.tr(args: [uri]))));
    }
  }

  void openEditSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withAlpha(150),
      builder: (_) => BlocProvider(
        create: (context) => ContactBloc(ContactsRepositorie()),
        child: AddContactSheet(contact: widget.contact),
      ),
    );
  }

  Widget _actionTile({
    required String title,
    required VoidCallback onTap,
    bool showDivider = true,
    Widget? trailing,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 2),
            child: Row(
              children: [
                Expanded(
                  child: Text(title, style: ContactDetailsTheme.cardTitle),
                ),
                trailing ?? const SizedBox(height: 22, width: 22),
              ],
            ),
          ),
        ),
        if (showDivider) const Divider(height: 1, color: Colors.white12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: Background()),
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: ContactHeaderDelegate(
                  segment: segmentIndex,
                  onSegmentChanged: (value) =>
                      setState(() => segmentIndex = value),
                  contact: widget.contact,
                  name: name,
                  initials: initials,
                  onBack: () => Navigator.pop(context),
                  onEdit: () => openEditSheet(context),
                  onSms: () => openUri(context, 'smsto:$phone'),
                  onCall: () => openUri(context, 'tel:$phone'),
                  onVideo: () => openUri(context, 'tel:$phone'),
                  onMail: () => ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('no_email'.tr()))),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
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
                              "contact_photo_poster".tr(),
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () => openUri(context, 'tel:$phone'),
                                  borderRadius: BorderRadius.circular(16),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 2,
                                      right: 6,
                                      bottom: 2,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "mobile".tr(),
                                          style: ContactDetailsTheme.label,
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          phone,
                                          style: ContactDetailsTheme.cardValue,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Icon(
                                _isFavorite
                                    ? Icons.star_rounded
                                    : Icons.star_border_rounded,
                                color: _isFavorite
                                    ? Colors.white
                                    : Colors.white38,
                                size: 28,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Divider(height: 1, color: Colors.white12),
                          const SizedBox(height: 12),
                          Text(
                            "notes".tr(),
                            style: ContactDetailsTheme.cardTitle,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(50),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Colors.white12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            child: TextField(
                              controller: _notesCtrl,
                              onChanged: _onNotesChanged,
                              maxLines: 3,
                              minLines: 1,
                              style: ContactDetailsTheme.cardValue,
                              cursorColor: Colors.white70,
                              decoration: InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                hintText: "write_note".tr(),
                                hintStyle: const TextStyle(
                                  color: Colors.white38,
                                ),
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    BlurCard(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "add_emergency_contact".tr(),
                          style: ContactDetailsTheme.cardTitle,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    BlurCard(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "contact".tr(),
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
