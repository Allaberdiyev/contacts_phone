import 'package:contacts_phone/app/di/dependecy_injection.dart';
import 'package:contacts_phone/features/contacts/presentation/bloc/contacts_bloc.dart';
import 'package:contacts_phone/features/contacts/presentation/pages/contact_page.dart';
import 'package:contacts_phone/main/bloc/bloc/theme_bloc.dart';
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
      ],
      child: const ContactsPage(),
    );
  }
}
