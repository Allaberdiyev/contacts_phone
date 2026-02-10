import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:contacts_phone/core/widgets/icon_widget.dart';
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
      ).showSnackBar(const SnackBar(content: Text("Qo'ng'iroq ochilmadi")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bsSize = (diameter * 0.60);
    final iconSize = (callDiameter * 0.40);

    return Row(
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
              onTap: () => _call(context),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Center(
                child: IgnorePointer(
                  child: IconWidget(
                    type: IconContentType.image,
                    image: Image.asset(
                      'assets/pictures/phone_icon.png',
                      fit: BoxFit.cover,
                      color: Colors.white,
                    ),
                    selected: false,
                    isDark: true,
                    onTap: () => _call(context),
                    iconSize: iconSize,
                    radius: 999,
                  ),
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
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 160),
              child: showBackspace
                  ? BackspaceButton(
                      key: const ValueKey('bs'),
                      size: bsSize,
                      onTap: onBackspace,
                      onLongPress: onClearAll,
                    )
                  : const SizedBox(
                      key: ValueKey('no_bs'),
                      width: 56,
                      height: 56,
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
