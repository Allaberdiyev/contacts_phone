import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppPalette {
  final Color bg;
  final Color surface;
  final Color surface2;
  final Color separator;
  final Color primary;
  final Color callGreen;
  final Color danger;
  final Color text;
  final Color text2;
  final Color text3;
  final Color iconInactive;
  final Color keypadFill;
  final Color keypadHi;
  final Color keypadBorder;
  final Color navBg;
  final Color navBorder;
  final Color navShadow;
  final Color navSelected;
  final Color navSplash;
  final Color navHighlight;
  final Color segmentBg;
  final Color segmentThumb;
  final Color segmentTextActive;
  final Color segmentTextInactive;
  final Color recentsHeaderBg;
  final Color recentsTitleColor;

  final Color recentsGlassBg;
  final Color recentsGlassBorder;
  final Color recentsGlassText;
  final Color recentsGlassIcon;

  final Color recentsSegBg;
  final Color recentsSegBorder;
  final Color recentsSegThumb;
  final Color recentsSegTextActive;
  final Color recentsSegTextInactive;

  final Color recentsSearchBg;
  final Color recentsSearchIcon;
  final Color recentsSearchText;
  final Color recentsSearchHint;
  final Color searchBubbleBg;
  final Color searchBubbleBorder;
  final Color searchBubbleAvatarBg;
  final Color searchBubbleTitle;
  final Color searchBubbleSub;
  final Color searchBubbleDivider;
  final Color transparent;
  final Color avatarHighlight;
  final Color sheetAddBadgeBg;
  final Color sheetAddBadgeBorder;
  final Color sheetAddBadgeIcon;
  final Color actionBtnBg;
  final Color actionBtnBgDisabled;
  final Color actionBtnBorder;
  final Color actionBtnIcon;
  final Color actionBtnIconDisabled;

  const AppPalette({
    required this.bg,
    required this.surface,
    required this.surface2,
    required this.separator,
    required this.primary,
    required this.callGreen,
    required this.danger,
    required this.text,
    required this.text2,
    required this.text3,
    required this.iconInactive,
    required this.keypadFill,
    required this.keypadHi,
    required this.keypadBorder,
    required this.navBg,
    required this.navBorder,
    required this.navShadow,
    required this.navSelected,
    required this.navSplash,
    required this.navHighlight,
    required this.segmentBg,
    required this.segmentThumb,
    required this.segmentTextActive,
    required this.segmentTextInactive,
    required this.recentsHeaderBg,
    required this.recentsTitleColor,

    required this.recentsGlassBg,
    required this.recentsGlassBorder,
    required this.recentsGlassText,
    required this.recentsGlassIcon,

    required this.recentsSegBg,
    required this.recentsSegBorder,
    required this.recentsSegThumb,
    required this.recentsSegTextActive,
    required this.recentsSegTextInactive,

    required this.recentsSearchBg,
    required this.recentsSearchIcon,
    required this.recentsSearchText,
    required this.recentsSearchHint,
    required this.searchBubbleBg,
    required this.searchBubbleBorder,
    required this.searchBubbleAvatarBg,
    required this.searchBubbleTitle,
    required this.searchBubbleSub,
    required this.searchBubbleDivider,
    required this.transparent,
    required this.avatarHighlight,
    required this.sheetAddBadgeBg,
    required this.sheetAddBadgeBorder,
    required this.sheetAddBadgeIcon,
    required this.actionBtnBg,
    required this.actionBtnBgDisabled,
    required this.actionBtnBorder,
    required this.actionBtnIcon,
    required this.actionBtnIconDisabled,
  });

  static const dark = AppPalette(
    bg: Color(0xFF000000),
    surface: Color(0xFF1C1C1E),
    surface2: Color(0xFF2C2C2E),
    separator: Color(0xFF2C2C2E),
    primary: Color(0xFF0A84FF),
    callGreen: Color(0xFF30D158),
    danger: Color(0xFFFF453A),
    text: Color(0xFFFFFFFF),
    text2: Color(0xB3FFFFFF),
    text3: Color(0x61FFFFFF),
    iconInactive: Color(0x8AFFFFFF),
    keypadFill: Color(0xFF1C1C1E),
    keypadHi: Color(0xFF2A2A2A),
    keypadBorder: Color(0x1FFFFFFF),

    navBg: Color(0xB81C1C1E),
    navBorder: Color(0x8C2C2C2E),
    navShadow: Color(0x59000000),
    navSelected: Color(0x380A84FF),
    navSplash: Color(0x1A0A84FF),
    navHighlight: Color(0x100A84FF),
    segmentBg: Color(0xB81C1C1E),
    segmentThumb: Color(0xFF2C2C2E),
    segmentTextActive: Color(0xFFFFFFFF),
    segmentTextInactive: Color(0xB3FFFFFF),
    recentsHeaderBg: Color(0xFF000000),
    recentsTitleColor: Color(0xFFFFFFFF),

    recentsGlassBg: Color(0x1AFFFFFF),
    recentsGlassBorder: Color(0x29FFFFFF),
    recentsGlassText: Color(0xFFFFFFFF),
    recentsGlassIcon: Color(0xFFFFFFFF),

    recentsSegBg: Color(0x1AFFFFFF),
    recentsSegBorder: Color(0x29FFFFFF),
    recentsSegThumb: Color(0x1FFFFFFF),
    recentsSegTextActive: Color(0xF2FFFFFF),
    recentsSegTextInactive: Color(0xB3FFFFFF),

    recentsSearchBg: Color(0xFF191919),
    recentsSearchIcon: Color(0xB3FFFFFF),
    recentsSearchText: Color(0xFFFFFFFF),
    recentsSearchHint: Color(0x3DFFFFFF),
    searchBubbleBg: Color(0x1AFFFFFF),
    searchBubbleBorder: Color(0x0FFFFFFF),
    searchBubbleAvatarBg: Color(0x1AFFFFFF),
    searchBubbleTitle: Color(0xF2FFFFFF),
    searchBubbleSub: Color(0x8AFFFFFF),
    searchBubbleDivider: Color(0x1AFFFFFF),
    transparent: Color(0x00000000),
    avatarHighlight: Color(0x29FFFFFF),
    sheetAddBadgeBg: Color(0xFFFFFFFF),
    sheetAddBadgeBorder: Color(0xFF3A3A3C),
    sheetAddBadgeIcon: Color(0xFF3A3A3C),
    actionBtnBg: Color(0x1AFFFFFF),
    actionBtnBgDisabled: Color(0x0FFFFFFF),
    actionBtnBorder: Color(0x1AFFFFFF),
    actionBtnIcon: Color(0xF2FFFFFF),
    actionBtnIconDisabled: Color(0x59FFFFFF),
  );

  static const light = AppPalette(
    bg: Color(0xFFFFFFFF),
    surface: Color(0xFFF2F2F7),
    surface2: Color(0xFFE5E5EA),
    separator: Color(0xFFE5E5EA),
    primary: Color(0xFF007AFF),
    callGreen: Color(0xFF34C759),
    danger: Color(0xFFFF3B30),
    text: Color(0xFF000000),
    text2: Color(0x8A000000),
    text3: Color(0x61000000),
    iconInactive: Color(0x73000000),
    keypadFill: Color(0xFFE5E5EA),
    keypadHi: Color(0xFFF4F4F4),
    keypadBorder: Color(0x1F000000),

    navBg: Color(0xDDF2F2F7),
    navBorder: Color(0xC0E5E5EA),
    navShadow: Color(0x2E000000),
    navSelected: Color(0x24007AFF),
    navSplash: Color(0x1A007AFF),
    navHighlight: Color(0x10007AFF),
    segmentBg: Color(0xFFF2F2F7),
    segmentThumb: Color(0xFFFFFFFF),
    segmentTextActive: Color(0xFF000000),
    segmentTextInactive: Color(0x8A000000),
    recentsHeaderBg: Color(0xFFFFFFFF),
    recentsTitleColor: Color(0xFF000000),

    recentsGlassBg: Color(0xFFF2F2F7),
    recentsGlassBorder: Color(0xFFE5E5EA),
    recentsGlassText: Color(0xFF000000),
    recentsGlassIcon: Color(0xFF000000),

    recentsSegBg: Color(0xFFF2F2F7),
    recentsSegBorder: Color(0xFFE5E5EA),
    recentsSegThumb: Color(0xFFFFFFFF),
    recentsSegTextActive: Color(0xFF000000),
    recentsSegTextInactive: Color(0x8A000000),

    recentsSearchBg: Color(0xFFE5E5EA),
    recentsSearchIcon: Color(0x8A000000),
    recentsSearchText: Color(0xFF000000),
    recentsSearchHint: Color(0x61000000),
    searchBubbleBg: Color(0xFFF2F2F7),
    searchBubbleBorder: Color(0xFFE5E5EA),
    searchBubbleAvatarBg: Color(0xFFFFFFFF),
    searchBubbleTitle: Color(0xFF000000),
    searchBubbleSub: Color(0x8A000000),
    searchBubbleDivider: Color(0xFFE5E5EA),
    transparent: Color(0x00000000),
    avatarHighlight: Color(0x29FFFFFF),
    sheetAddBadgeBg: Color(0xFFF4F4F4),
    sheetAddBadgeBorder: Color(0xFF3A3A3C),
    sheetAddBadgeIcon: Color(0xFF3A3A3C),
    actionBtnBg: Color(0xFFF2F2F7),
    actionBtnBgDisabled: Color(0xFFE5E5EA),
    actionBtnBorder: Color(0xFFE5E5EA),
    actionBtnIcon: Color(0xFF000000),
    actionBtnIconDisabled: Color(0x8A000000),
  );
}

class AppColors {
  static AppPalette of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? AppPalette.dark : AppPalette.light;
  }
}

class AppTheme {
  static ThemeData light() => _build(AppPalette.light, Brightness.light);
  static ThemeData dark() => _build(AppPalette.dark, Brightness.dark);

  static ThemeData _build(AppPalette p, Brightness b) {
    final cs = ColorScheme(
      brightness: b,
      primary: p.primary,
      onPrimary: Colors.white,
      secondary: p.callGreen,
      onSecondary: b == Brightness.dark ? Colors.black : Colors.white,
      error: p.danger,
      onError: b == Brightness.dark ? Colors.black : Colors.white,
      background: p.bg,
      onBackground: p.text,
      surface: p.surface,
      onSurface: p.text,
      outline: p.separator,
      outlineVariant: p.separator,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: b,
      colorScheme: cs,
      scaffoldBackgroundColor: p.bg,

      dividerTheme: DividerThemeData(color: p.separator, thickness: 0.7),

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: p.text,
        systemOverlayStyle: b == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),

      iconTheme: IconThemeData(color: p.text),
    );
  }
}

class ContactDetailsTheme {
  static const List<Color> backgroundColors = [
    Color(0xFF958DB9),
    Color(0xFF635B97),
    Color(0xFF584E77),
    Color(0xFF221E38),
  ];
  
  static const List<double> backgroundStops = [0.0, 0.40, 0.70, 1.0];

  static const Color glassColor = Color(0xFF0A0814);
  static const Color cardTint = Color(0xFF3E3653);
  static const Color actionTint = Color(0xFF2B2540);

  static const TextStyle title = TextStyle(
    color: Colors.white,
    fontSize: 40,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
  );

  static const TextStyle cardTitle = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle cardValue = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle label = TextStyle(color: Colors.white70, fontSize: 15);
  static const TextStyle muted = TextStyle(color: Colors.white70, fontSize: 16);
}
