import 'dart:ui';
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
    final bg = enabled ? Colors.white.withOpacity(0.10) : Colors.white.withOpacity(0.06);
    final ic = enabled ? Colors.white.withOpacity(0.95) : Colors.white.withOpacity(0.35);

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
              border: Border.all(color: Colors.white.withOpacity(0.10)),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: ic, size: 28),
          ),
        ),
      ),
    );
  }
}
