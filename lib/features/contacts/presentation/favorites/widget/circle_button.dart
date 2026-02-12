import 'package:contacts_phone/app/theme.dart';
import 'package:flutter/material.dart';

class CircleFavButton extends StatelessWidget {
  final bool isDark; 
  final VoidCallback onTap;
  final IconData icon;

  const CircleFavButton({
    super.key,
    required this.isDark,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);

    final bg = Theme.of(context).brightness == Brightness.dark
        ? p.surface2
        : p.surface;
    final border = p.keypadBorder;
    final iconColor = p.text;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
          border: Border.all(color: border, width: 1),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
    );
  }
}
