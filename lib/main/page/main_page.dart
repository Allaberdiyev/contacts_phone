import 'dart:ui';
import 'package:contacts_phone/app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:contacts_phone/features/contacts/presentation/contacts/pages/contact_page.dart';
import 'package:contacts_phone/features/contacts/presentation/favorites/page/favorite_page.dart';
import 'package:contacts_phone/features/contacts/presentation/keypad/pages/keypad_page.dart';
import 'package:contacts_phone/features/contacts/presentation/recents/pages/recents_page.dart';
import 'package:contacts_phone/features/contacts/presentation/voicemail/pages/voicemail_page.dart';
import 'package:contacts_phone/main/bloc/bottom_navigation_bloc.dart';
import 'package:contacts_phone/main/bloc/bottom_navigation_event.dart';
import 'package:contacts_phone/main/bloc/bottom_navigation_state.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  static const double _navHeight = 71;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const FavoritePage(title: "Favorites"),
      const RecentsPage(title: "Recents"),
      const ContactsPage(title: "Contacts"),
      const KeypadPage(),
      const VoicemailPage(title: "Voicemail"),
    ];

    return BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
      builder: (context, state) {
        return Scaffold(
          extendBody: true,
          body: IndexedStack(index: state.index, children: pages),
          bottomNavigationBar: _FloatingPillNavBar(
            currentIndex: state.index,
            onTap: (i) => context.read<BottomNavigationBloc>().add(
                  BottomTabChanged(i),
                ),
          ),
        );
      },
    );
  }
}

class _FloatingPillNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _FloatingPillNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);

    final items = const <_NavItemData>[
      _NavItemData(icon: Icons.star, label: "Favorites"),
      _NavItemData(icon: Icons.access_time_filled_sharp, label: "Recents"),
      _NavItemData(icon: Icons.account_circle_rounded, label: "Contacts"),
      _NavItemData(icon: Icons.dialpad, label: "Keypad"),
      _NavItemData(icon: Icons.voicemail, label: "Voicemail"),
    ];

    final Color navBg = p.navBg;
    final Color borderColor = p.navBorder;
    final Color shadowColor = p.navShadow;

    final Color unselectedIcon = p.iconInactive;
    final Color unselectedText = p.text3;

    final Color splash = p.navSplash;
    final Color highlight = p.navHighlight;

    final Color selectedPill = p.navSelected;

    return SafeArea(
      minimum: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              height: MainPage._navHeight,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: navBg,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: borderColor, width: 1),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 40,
                    spreadRadius: 0,
                    offset: const Offset(0, 10),
                    color: shadowColor,
                  ),
                ],
              ),
              child: Row(
                children: List.generate(items.length, (i) {
                  final selected = i == currentIndex;
                  final data = items[i];

                  final Color iconColor =
                      selected ? p.primary : unselectedIcon;
                  final Color textColor =
                      selected ? p.primary : unselectedText;

                  final Color pillBg =
                      selected ? selectedPill : Colors.transparent;

                  return Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(32),
                        splashColor: splash,
                        highlightColor: highlight,
                        onTap: () => onTap(i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          curve: Curves.easeOutCubic,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: pillBg,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(data.icon, size: 25, color: iconColor),
                              const SizedBox(height: 2),
                              Text(
                                data.label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  height: 1.0,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItemData {
  final IconData icon;
  final String label;
  const _NavItemData({required this.icon, required this.label});
}
