import 'package:contacts_phone/main/bloc/bottom_navigation_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:contacts_phone/features/contacts/data/repositories/contacts_repositorie.dart';
import 'package:contacts_phone/features/contacts/presentation/contacts/bloc/contacts_bloc.dart';
import 'package:contacts_phone/main/bloc/theme_bloc.dart';

final getIt = GetIt.instance;

void setUp() {
  getIt.registerFactory<ThemeBloc>(() => ThemeBloc());

  getIt.registerLazySingleton<ContactsRepositorie>(() => ContactsRepositorie());
  getIt.registerFactory<ContactBloc>(
    () => ContactBloc(getIt<ContactsRepositorie>()),
  );
  getIt.registerFactory<BottomNavigationBloc>(() => BottomNavigationBloc());
}
