import 'dart:ui';
import 'package:contacts_phone/core/utils/colors/app_colors.dart';
import 'package:flutter/material.dart';

class BlurCard extends StatelessWidget {
  final Widget child;
  const BlurCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: ContactDetailsTheme.cardTint.withOpacity(0.58),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withOpacity(0.10)),
          ),
          child: child,
        ),
      ),
    );
  }
}
