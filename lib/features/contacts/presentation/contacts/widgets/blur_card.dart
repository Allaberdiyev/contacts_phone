import 'dart:ui';
import 'package:contacts_phone/app/theme.dart';
import 'package:flutter/material.dart';

class BlurCard extends StatelessWidget {
  final Widget child;
  const BlurCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);


    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Color(0x943E3653),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: p.keypadBorder, width: 1),
          ),
          child: child,
        ),
      ),
    );
  }
}
