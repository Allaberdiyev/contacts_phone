import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:contacts_phone/core/widgets/icon_widget.dart';

class KeypadPage extends StatefulWidget {
  final double bottomOverlay;

  const KeypadPage({super.key, this.bottomOverlay = 0});

  @override
  State<KeypadPage> createState() => _KeypadPageState();
}

class _KeypadPageState extends State<KeypadPage> {
  String digits = '';
  static const int maxDigits = 15;

  void _tap(String v) {
    if (!RegExp(r'^\d$').hasMatch(v)) {
      HapticFeedback.lightImpact();
      return;
    }
    if (digits.length >= maxDigits) {
      HapticFeedback.lightImpact();
      return;
    }
    HapticFeedback.lightImpact();
    setState(() => digits += v);
  }

  void _backspace() {
    if (digits.isEmpty) return;
    HapticFeedback.lightImpact();
    setState(() => digits = digits.substring(0, digits.length - 1));
  }

  void _clearAll() {
    if (digits.isEmpty) return;
    HapticFeedback.mediumImpact();
    setState(() => digits = '');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    final side = 70.0;
    final spaceWith = 40.0;
    final spaceHieght = 15.0;

    final availableW = size.width - side * 2;
    final diameter = (availableW - spaceWith * 2) / 3;
    final callDiameter = diameter * 0.9;

    final display = PhoneFormat.last9UzHyphen(digits);
    final topH = (size.height * 0.18).clamp(70.0, 120.0);

    Widget key(String t, String sub) {
      final showSub = sub.isNotEmpty;

      final titleSize = (diameter * 0.42).clamp(26.0, 44.0);
      final subSize = (diameter * 0.13).clamp(9.0, 12.0);

      return GestureDetector(
        onTap: () => _tap(t),
        child: Container(
          width: diameter,
          height: diameter,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.08),
            border: Border.all(color: Colors.white.withOpacity(0.07)),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  t,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: titleSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (showSub)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      sub,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: subSize,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.4,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    Widget row3(Widget a, Widget b, Widget c) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          a,
          SizedBox(width: spaceWith),
          b,
          SizedBox(width: spaceWith),
          c,
        ],
      );
    }

    final backspace = AnimatedSwitcher(
      duration: const Duration(milliseconds: 1),
      child: digits.isEmpty
          ? const SizedBox(width: 1, height: 1, key: ValueKey('no_bs'))
          : GestureDetector(
              onTap: _backspace,
              onLongPress: _clearAll,
              child: SizedBox(
                width: 10,
                height: 10,

                child: const Icon(
                  Icons.backspace_outlined,
                  color: Colors.white,
                ),
              ),
            ),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            children: [
              SizedBox(
                height: topH,
                width: double.infinity,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: side),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.center,
                      child: Text(
                        display,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 44,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              row3(key('1', ''), key('2', 'ABC'), key('3', 'DEF')),
              SizedBox(height: spaceHieght),
              row3(key('4', 'GHI'), key('5', 'JKL'), key('6', 'MNO')),
              SizedBox(height: spaceHieght),
              row3(key('7', 'PQRS'), key('8', 'TUV'), key('9', 'WXYZ')),
              SizedBox(height: spaceHieght),
              row3(
                GestureDetector(
                  onTap: () => HapticFeedback.lightImpact(),
                  child: key('*', ''),
                ),
                key('0', '+'),
                GestureDetector(
                  onTap: () => HapticFeedback.lightImpact(),
                  child: key('#', ''),
                ),
              ),
              SizedBox(height: spaceHieght * 1.6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: diameter, height: diameter),
                  SizedBox(
                    width: callDiameter,
                    height: callDiameter,
                    child: Material(
                      color: const Color(0xFF178A3A),
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => debugPrint('CALL: $digits'),
                        child: Center(
                          child: IconWidget(
                            type: IconContentType.image,
                            image: Image.asset(
                              'assets/pictures/phone_icon.png',
                              fit: BoxFit.contain,
                              color: Colors.white,
                            ),
                            selected: false,
                            isDark: true,
                            onTap: () {},
                            iconSize: (callDiameter * 0.35).clamp(22.0, 34.0),
                            radius: 50,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: diameter,
                    height: diameter,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: backspace,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PhoneFormat {
  static String last9UzHyphen(String input) {
    final d = input.replaceAll(RegExp(r'\D'), '');
    if (d.isEmpty) return '';
    if (d.length <= 9) return _uz9(d);

    final prefix = d.substring(0, d.length - 9);
    final last9 = d.substring(d.length - 9);
    return '$prefix-${_uz9(last9)}';
  }

  static String _uz9(String nine) {
    final n = nine;
    if (n.length <= 2) return n;
    if (n.length <= 5) return '${n.substring(0, 2)}-${n.substring(2)}';
    if (n.length <= 7) {
      return '${n.substring(0, 2)}-${n.substring(2, 5)}-${n.substring(5)}';
    }
    return '${n.substring(0, 2)}-${n.substring(2, 5)}-${n.substring(5, 7)}-${n.substring(7)}';
  }
}
