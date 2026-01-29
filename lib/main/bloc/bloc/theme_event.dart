part of 'theme_bloc.dart';

@immutable
sealed class ThemeEvent {}

final class LoadTheme extends ThemeEvent {}

final class SetLightTheme extends ThemeEvent {}

final class SetDarkTheme extends ThemeEvent {}

final class SetSystemTheme extends ThemeEvent {}
