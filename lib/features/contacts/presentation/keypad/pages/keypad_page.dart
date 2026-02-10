import 'package:contacts_phone/features/contacts/presentation/keypad/widgets/create_open.dart';
import 'package:contacts_phone/features/contacts/presentation/keypad/widgets/dial_displey.dart';
import 'package:contacts_phone/features/contacts/presentation/keypad/widgets/dial_pad.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:contacts_phone/features/contacts/data/models/contacts_model.dart';
import 'package:contacts_phone/features/contacts/presentation/contacts/bloc/contacts_bloc.dart';
import 'package:contacts_phone/features/contacts/presentation/contacts/bloc/contacts_state.dart';
import 'package:contacts_phone/features/contacts/presentation/contacts/pages/conatact_details_page.dart';

import '../utils/dial_search.dart';
import '../utils/phone_format.dart';
import '../widgets/call_row.dart';
import '../widgets/search_bubble.dart';

class KeypadPage extends StatefulWidget {
  final double bottomOverlay;

  const KeypadPage({super.key, this.bottomOverlay = 0});

  @override
  State<KeypadPage> createState() => _KeypadPageState();
}

class _KeypadPageState extends State<KeypadPage> {
  String dial = '';
  static const int maxDigits = 15;

  List<ContactsModel> _contactsFromState(ContactState state) {
    try {
      final s = state as dynamic;
      final dynamic raw =
          s.contacts ?? s.contactList ?? s.items ?? s.data ?? s.list;
      if (raw is List<ContactsModel>) return raw;
      if (raw is List) return raw.whereType<ContactsModel>().toList();
      return <ContactsModel>[];
    } catch (_) {
      return <ContactsModel>[];
    }
  }

  int _digitsCount() => PhoneFormat.digitsOnly(dial).length;

  void _append(String v) {
    final isDigit = RegExp(r'^\d$').hasMatch(v);
    if (isDigit) {
      if (_digitsCount() >= maxDigits) {
        HapticFeedback.lightImpact();
        return;
      }
      HapticFeedback.lightImpact();
      setState(() => dial += v);
      return;
    }

    if (v == '*' || v == '#' || v == '+') {
      HapticFeedback.lightImpact();
      setState(() => dial += v);
      return;
    }

    HapticFeedback.lightImpact();
  }

  void _backspace() {
    if (dial.isEmpty) return;
    HapticFeedback.lightImpact();
    setState(() => dial = dial.substring(0, dial.length - 1));
  }

  void _clearAll() {
    if (dial.isEmpty) return;
    HapticFeedback.mediumImpact();
    setState(() => dial = '');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    final side = (size.width * 0.2);
    final spaceWith = (size.width * 0.1);
    final spaceHeight = (size.height * 0.018);

    final availableW = size.width - side * 2.3;
    final diameter = ((availableW - spaceWith * 0.4) / 3);
    final callDiameter = (diameter * 0.92);

    final topH = (size.height * 0.2);

    final qDigits = PhoneFormat.digitsOnly(dial);
    final display = PhoneFormat.displayText(dial);

    return BlocBuilder<ContactBloc, ContactState>(
      builder: (context, state) {
        final contacts = _contactsFromState(state);

        final matches = DialSearch.searchContacts(
          contacts: contacts,
          queryDigits: qDigits,
        );

        final isSavedExact = DialSearch.isSavedUz9(
          contacts: contacts,
          inputDigits: qDigits,
          getPhone: (c) => c.phoneNumber,
        );

        final showAdd = qDigits.isNotEmpty && !isSavedExact;

        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    DialDisplay(height: topH, side: side, text: display),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      child: matches.isEmpty
                          ? const SizedBox(height: 70)
                          : Padding(
                              padding: EdgeInsets.symmetric(horizontal: side),
                              child: SearchBubble(
                                contact: matches.first,
                                total: matches.length,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ContactDetailsPage(
                                        contact: matches.first,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                    ),
                    const Spacer(),
                    DialPad(
                      diameter: diameter,
                      spaceWith: spaceWith,
                      spaceHeight: spaceHeight,
                      onKey: _append,
                    ),
                    SizedBox(height: spaceHeight * 1),
                    CallRow(
                      diameter: diameter,
                      callDiameter: callDiameter,
                      dial: dial,
                      showBackspace: dial.isNotEmpty,
                      onBackspace: _backspace,
                      onClearAll: _clearAll,
                    ),
                  ],
                ),

                Positioned(
                  top: 6,
                  right: side - 70,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 160),
                    child: showAdd
                        ? IconButton(
                            key: const ValueKey('add'),
                            icon: const Icon(
                              CupertinoIcons.person_crop_circle_badge_plus,
                              color: Colors.white,
                              size: 32,
                            ),
                            onPressed: () => openCreateNew(context, qDigits),
                          )
                        : const SizedBox(width: 44, height: 44),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
