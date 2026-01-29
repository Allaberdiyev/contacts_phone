import 'package:bloc/bloc.dart';
import 'package:contacts_phone/core/services/app_share_prefs.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';


part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeInitial(ThemeMode.light)) {
    on<LoadTheme>(_onLoadTheme);
    on<SetLightTheme>(_onSetLight);
    on<SetDarkTheme>(_onSetDark);
    on<SetSystemTheme>(_onSetSystem);
  }

  Future<void> _onLoadTheme(LoadTheme event, Emitter<ThemeState> emit) async {
    final mode = await AppSharePrefs.loadThemeMode();
    emit(ThemeInitial(mode));
  }

  Future<void> _onSetLight(SetLightTheme event, Emitter<ThemeState> emit) async {
    await AppSharePrefs.saveThemeMode(ThemeMode.light);
    emit(ThemeInitial(ThemeMode.light));
  }

  Future<void> _onSetDark(SetDarkTheme event, Emitter<ThemeState> emit) async {
    await AppSharePrefs.saveThemeMode(ThemeMode.dark);
    emit(ThemeInitial(ThemeMode.dark));
  }

  Future<void> _onSetSystem(SetSystemTheme event, Emitter<ThemeState> emit) async {
    await AppSharePrefs.saveThemeMode(ThemeMode.system);
    emit(ThemeInitial(ThemeMode.system));
  }
}
