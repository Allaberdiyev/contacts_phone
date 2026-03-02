import 'package:contacts_phone/app/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'backspace_button.dart';

class CallRow extends StatelessWidget {
  final double diameter;
  final double callDiameter;
  final String dial;

  final bool showBackspace;
  final VoidCallback onBackspace;
  final VoidCallback onClearAll;

  const CallRow({
    super.key,
    required this.diameter,
    required this.callDiameter,
    required this.dial,
    required this.showBackspace,
    required this.onBackspace,
    required this.onClearAll,
  });

  Future<void> _call(BuildContext context) async {
    final number = dial.replaceAll(RegExp(r'[^0-9+\*#]'), '');
    if (number.isEmpty) return;

    final uri = Uri(scheme: 'tel', path: number);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (!ok && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('call_failed'.tr())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);

    final bsSize = diameter * 0.60;
    final iconSize = callDiameter * 0.42;

    final callBg = p.callGreen;
    final callIconColor = Colors.white;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: diameter, height: diameter),

        SizedBox(
          width: callDiameter,
          height: callDiameter,
          child: Material(
            color: callBg,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => _call(context),
              splashColor: Colors.white.withAlpha(200),
              highlightColor: Colors.white.withAlpha(100),
              child: Center(
                child: Image.asset(
                  'assets/pictures/phone_icon.png',
                  width: iconSize,
                  height: iconSize,
                  fit: BoxFit.contain,
                  color: callIconColor,
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
            child: showBackspace
                ? BackspaceButton(
                    key: const ValueKey('bs'),
                    size: bsSize,
                    onTap: onBackspace,
                    onLongPress: onClearAll,
                  )
                : const SizedBox(key: ValueKey('no_bs'), width: 56, height: 56),
          ),
        ),
      ],
    );
  }
}
