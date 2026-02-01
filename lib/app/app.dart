import 'package:contacts_phone/app/di/dependecy_injection.dart';
import 'package:contacts_phone/features/contacts/presentation/contacts/bloc/contacts_bloc.dart';
import 'package:contacts_phone/main/bloc/bottom_navigation_bloc.dart';
import 'package:contacts_phone/main/bloc/theme_bloc.dart';
import 'package:contacts_phone/main/page/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          create: (_) => getIt<ThemeBloc>()..add(LoadTheme()),
        ),
        BlocProvider<ContactBloc>(create: (_) => getIt<ContactBloc>()),

        BlocProvider<BottomNavigationBloc>(
          create: (_) => getIt<BottomNavigationBloc>(),
        ),
      ],
      child: MainPage(),
    );
  }
}
