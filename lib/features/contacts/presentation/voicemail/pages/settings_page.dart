import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:contacts_phone/app/theme.dart';
import 'package:contacts_phone/main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  late ThemeMode currentTheme;
  late String currentLang;
  bool isNotificationEnabled = true;

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    currentTheme = MainApp.themeNotifier.value;

    _loadNotificationSetting();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  Future<void> _loadNotificationSetting() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isNotificationEnabled = prefs.getBool('notifications_enabled') ?? true;
    });
  }

  Future<void> _toggleNotification(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);

    setState(() {
      isNotificationEnabled = value;
    });

    if (value) {
      await FirebaseMessaging.instance.subscribeToTopic('all_users');
    } else {
      await FirebaseMessaging.instance.unsubscribeFromTopic('all_users');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      currentLang = context.locale.languageCode;
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: palette.bg,
      appBar: AppBar(
        backgroundColor: palette.bg,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: palette.text),
        title: Text(
          "settings".tr(),
          style: TextStyle(
            color: palette.text,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              _buildSettingRow(
                title: "language".tr(),
                palette: palette,
                switchWidget: SizedBox(
                  width: 120,
                  child: AnimatedToggleSwitch<String>.rollingByHeight(
                    height: 34.0,
                    current: currentLang,
                    values: const ['ru', 'uz', 'en'],
                    onChanged: (value) async {
                      setState(() => currentLang = value);
                      await context.setLocale(Locale(value));
                    },
                    indicatorSize: const Size.square(1),
                    borderWidth: 0.6,
                    spacing: 0,
                    style: ToggleStyle(
                      borderColor: palette.separator.withAlpha(20),
                      borderRadius: BorderRadius.circular(75.0),
                      backgroundColor: isDark
                          ? const Color(0xFF2B323B)
                          : const Color(0xFFE5E5EA),
                      indicatorColor: Colors.teal,
                    ),
                    iconBuilder: (value, foreground) {
                      final pngs = {
                        'ru': 'assets/png/ic_ru_64.png',
                        'uz': 'assets/png/ic_uz_64.png',
                        'en': 'assets/png/ic_uk_256.png',
                      };

                      return ClipRRect(
                        borderRadius: BorderRadius.circular(75.0),
                        child: Image.asset(
                          pngs[value] ?? 'assets/png/ic_uz_64.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Text(
                              _flag(value),
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              _buildSettingRow(
                title: "theme".tr(),
                palette: palette,
                switchWidget: SizedBox(
                  width: 80,
                  child: AnimatedToggleSwitch<ThemeMode>.rollingByHeight(
                    height: 34.0,
                    current: currentTheme,
                    values: const [ThemeMode.dark, ThemeMode.light],
                    onChanged: (value) async {
                      setState(() => currentTheme = value);
                      await MainApp.setTheme(value);
                    },
                    indicatorSize: const Size.square(1),
                    borderWidth: 0.6,
                    spacing: 0,
                    style: ToggleStyle(
                      borderColor: palette.separator.withAlpha(20),
                      borderRadius: BorderRadius.circular(75.0),
                      backgroundColor: isDark
                          ? const Color(0xFF2B323B)
                          : const Color(0xFFE5E5EA),
                      indicatorColor: Colors.teal,
                    ),
                    iconBuilder: (value, foreground) {
                      return Icon(
                        value == ThemeMode.light
                            ? Icons.wb_sunny
                            : Icons.nightlight_round,
                        size: 20,
                        color: foreground
                            ? Colors.white
                            : palette.text.withAlpha(128),
                      );
                    },
                  ),
                ),
              ),

              _buildSettingRow(
                title: "notifications".tr(),
                palette: palette,
                switchWidget: SizedBox(
                  width: 80,
                  child: AnimatedToggleSwitch<bool>.rollingByHeight(
                    height: 34.0,
                    current: isNotificationEnabled,
                    values: const [true, false],
                    onChanged: _toggleNotification,
                    indicatorSize: const Size.square(1),
                    borderWidth: 0.6,
                    spacing: 0,
                    style: ToggleStyle(
                      borderColor: palette.separator.withAlpha(20),
                      borderRadius: BorderRadius.circular(75.0),
                      backgroundColor: isDark
                          ? const Color(0xFF2B323B)
                          : const Color(0xFFE5E5EA),
                      indicatorColor: isNotificationEnabled
                          ? Colors.teal
                          : Colors.redAccent,
                    ),
                    iconBuilder: (value, foreground) {
                      return Icon(
                        value
                            ? Icons.notifications_active
                            : Icons.notifications_off,
                        size: 20,
                        color: foreground
                            ? Colors.white
                            : palette.text.withAlpha(128),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingRow({
    required String title,
    required AppPalette palette,
    required Widget switchWidget,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: palette.text,
            ),
          ),
          switchWidget,
        ],
      ),
    );
  }

  String _flag(String code) {
    switch (code) {
      case 'uz':
        return "🇺🇿";
      case 'ru':
        return "🇷🇺";
      case 'en':
        return "🇬🇧";
      default:
        return "🌐";
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
