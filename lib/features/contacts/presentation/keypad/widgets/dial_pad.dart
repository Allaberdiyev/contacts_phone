import 'package:flutter/material.dart';

import 'dial_key.dart';

class DialPad extends StatelessWidget {
  final double diameter;
  final double spaceWith;
  final double spaceHeight;
  final void Function(String v) onKey;

  const DialPad({
    super.key,
    required this.diameter,
    required this.spaceWith,
    required this.spaceHeight,
    required this.onKey,
  });

  Widget _row3(Widget a, Widget b, Widget c) {
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

  @override
  Widget build(BuildContext context) {
    final titleSize = (diameter * 0.42).clamp(26.0, 44.0);
    final subSize = (diameter * 0.13).clamp(9.0, 12.0);

    Widget key(String t, String sub, {VoidCallback? onLongPress}) {
      return DialKey(
        diameter: diameter,
        titleSize: titleSize,
        subSize: subSize,
        title: t,
        sub: sub,
        onTap: () => onKey(t),
        onLongPress: onLongPress,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _row3(key('1', ''), key('2', 'ABC'), key('3', 'DEF')),
        SizedBox(height: spaceHeight),
        _row3(key('4', 'GHI'), key('5', 'JKL'), key('6', 'MNO')),
        SizedBox(height: spaceHeight),
        _row3(key('7', 'PQRS'), key('8', 'TUV'), key('9', 'WXYZ')),
        SizedBox(height: spaceHeight),
        _row3(
          key('*', ''),
          key('0', '+', onLongPress: () => onKey('+')),
          key('#', ''),
        ),
      ],
    );
  }
}
