import 'package:contacts_phone/features/contacts/presentation/voicemail/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:contacts_phone/features/contacts/presentation/contacts/pages/contact_page.dart';
import 'package:contacts_phone/features/contacts/presentation/favorites/page/favorite_page.dart';
import 'package:contacts_phone/features/contacts/presentation/keypad/pages/keypad_page.dart';
import 'package:contacts_phone/features/contacts/presentation/recents/pages/recents_page.dart';

import 'package:contacts_phone/main/bloc/bottom_navigation_bloc.dart';
import 'package:contacts_phone/main/bloc/bottom_navigation_event.dart';
import 'package:contacts_phone/main/bloc/bottom_navigation_state.dart';

import 'floating_pill_nav_bar.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  static const _pages = <Widget>[
    FavoritePage(title: "Favorites"),
    RecentsPage(title: "Recents"),
    ContactsPage(title: "Contacts"),
    KeypadPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
      builder: (context, state) {
        return Scaffold(
          extendBody: true,
          body: IndexedStack(index: state.index, children: _pages),
          bottomNavigationBar: FloatingPillNavBar(
            currentIndex: state.index,
            onChanged: (i) =>
                context.read<BottomNavigationBloc>().add(BottomTabChanged(i)),
          ),
        );
      },
    );
  }
}
