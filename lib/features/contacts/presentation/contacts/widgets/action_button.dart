import 'dart:ui';
import 'package:contacts_phone/app/theme.dart';
import 'package:flutter/material.dart';

class IosActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool enabled;

  const IosActionButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);

    final bg = enabled ? p.actionBtnBg : p.actionBtnBgDisabled;
    final ic = enabled ? p.actionBtnIcon : p.actionBtnIconDisabled;

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: bg,
              border: Border.all(color: p.actionBtnBorder),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: ic, size: 28),
          ),
        ),
      ),
    );
  }
}
