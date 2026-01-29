import 'package:contacts_phone/app/app.dart';
import 'package:contacts_phone/app/di/dependecy_injection.dart';
import 'package:contacts_phone/app/router.dart';
import 'package:contacts_phone/core/services/app_share_prefs.dart';
import 'package:contacts_phone/core/services/notificaxtion_service.dart';
import 'package:contacts_phone/core/utils/colors/app_colors.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:easy_localization/easy_localization.dart';

import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  setUp();

  final savedThemeMode = await AppSharePrefs.loadThemeMode();
  final savedLocale = await AppSharePrefs.loadLocale();

  MainApp.themeNotifier.value = savedThemeMode;

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('uz'), Locale('ru'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: savedLocale,
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(
    ThemeMode.light,
  );

  static Future<void> setTheme(ThemeMode mode) async {
    themeNotifier.value = mode;
    await AppSharePrefs.saveThemeMode(mode);
  }

  static Future<void> setLocale(BuildContext context, Locale locale) async {
    await context.setLocale(locale);
    await AppSharePrefs.saveLocale(locale);
  }

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    NotificationService.instance.init();
  }

  ThemeData _lightTheme() {
    return ThemeData(
      colorScheme: ColorScheme.light(
        surface: Colors.white,
        primary: AppColors.whitegrey,
      ),
    );
  }

  ThemeData _darkTheme() {
    return ThemeData(
      colorScheme: ColorScheme.dark(
        surface: Colors.black,
        primary: AppColors.greydark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: MainApp.themeNotifier,
      builder: (_, mode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          theme: _lightTheme(),
          darkTheme: _darkTheme(),
          themeMode: mode,

          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,

          initialRoute: Routers.contactsPage,
          routes: {Routers.contactsPage: (_) => const App()},
        );
      },
    );
  }
}
