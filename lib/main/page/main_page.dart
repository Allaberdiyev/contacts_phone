import 'dart:ui';

import 'package:contacts_phone/core/utils/colors/app_colors.dart';
import 'package:contacts_phone/features/contacts/presentation/contacts/pages/contact_page.dart';
import 'package:contacts_phone/features/contacts/presentation/favorites/page/favorite_page.dart';
import 'package:contacts_phone/features/contacts/presentation/keypad/pages/keypad_page.dart';
import 'package:contacts_phone/features/contacts/presentation/recents/pages/recents_page.dart';
import 'package:contacts_phone/features/contacts/presentation/voicemail/pages/voicemail_page.dart';
import 'package:contacts_phone/main/bloc/bottom_navigation_bloc.dart';
import 'package:contacts_phone/main/bloc/bottom_navigation_event.dart';
import 'package:contacts_phone/main/bloc/bottom_navigation_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            onTap: (i) =>
                context.read<BottomNavigationBloc>().add(BottomTabChanged(i)),
          ),
        );
      },
    );
  }
}

class _FloatingPillNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _FloatingPillNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // final bottomInset = MediaQuery.of(context).padding.bottom;

    final items = <_NavItemData>[
      _NavItemData(icon: Icons.star, label: "Favorites"),
      _NavItemData(icon: Icons.access_time_filled_sharp, label: "Recents"),
      _NavItemData(icon: Icons.account_circle_rounded, label: "Contacts"),
      _NavItemData(icon: Icons.dialpad, label: "Keypad"),
      _NavItemData(icon: Icons.voicemail, label: "Voicemail"),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            height: MainPage._navHeight,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkgrey.withAlpha(50)
                  : Colors.white.withAlpha(50),

              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: isDark
                    ? Colors.white.withAlpha(50)
                    : Colors.white.withAlpha(500),
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 100,
                  color: AppColors.whitegrey.withAlpha(isDark ? 70 : 100),
                ),
              ],
            ),
            child: Row(
              children: List.generate(items.length, (i) {
                final selected = i == currentIndex;
                final data = items[i];

                return Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(40),
                    onTap: () => onTap(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: selected
                            ? (isDark
                                  ? Colors.white.withAlpha(300)
                                  : Colors.black.withAlpha(25))
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            data.icon,
                            size: 26,
                            color: selected
                                ? AppColors.blue
                                : (isDark ? AppColors.white : AppColors.dark),
                          ),
                          Text(
                            data.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: selected
                                  ? Colors.blueAccent
                                  : (isDark ? AppColors.white : AppColors.dark),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
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
  _NavItemData({required this.icon, required this.label});
}
