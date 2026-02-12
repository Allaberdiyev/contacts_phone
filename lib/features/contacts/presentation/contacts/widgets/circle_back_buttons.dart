import 'package:contacts_phone/app/theme.dart';
import 'package:flutter/material.dart';

class CircleBackButton extends StatelessWidget {
  final VoidCallback onTap;
  const CircleBackButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);

    final bg = ContactDetailsTheme.actionTint;
    final border = p.keypadBorder;
    final fg = p.text;

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
          border: Border.all(color: border, width: 1),
        ),
        child: Icon(Icons.arrow_back_ios_new_rounded, color: fg, size: 18),
      ),
    );
  }
}

class EditPillButton extends StatelessWidget {
  final VoidCallback onTap;
  const EditPillButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);

    final bg = ContactDetailsTheme.actionTint;
    final border = p.keypadBorder;
    final fg = p.text;

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: border, width: 1),
        ),
        child: Center(
          child: Text(
            "Edit",
            style: TextStyle(
              color: fg,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
