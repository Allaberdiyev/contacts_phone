import 'dart:ui';
import 'package:contacts_phone/app/theme.dart';
import 'package:flutter/material.dart';

class Segmented extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const Segmented({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    const w = 230.0;
    const h = 38.0;

    final bg = isDark ? p.surface2 : p.surface;
    final selectedBg = isDark ? p.surface : p.surface2;
    final border = p.keypadBorder;

    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: w,
          height: h,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: border, width: 1),
          ),
          child: Stack(
            children: [
              Container(
                alignment: value == 0
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: Container(
                  width: (w - 6) / 2,
                  height: h - 6,
                  decoration: BoxDecoration(
                    color: selectedBg,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              Row(
                children: [
                  _SegmentText(
                    title: "Details",
                    selected: value == 0,
                    onTap: () => onChanged(0),
                  ),
                  _SegmentText(
                    title: "Voicemails",
                    selected: value == 1,
                    onTap: () => onChanged(1),
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

class _SegmentText extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _SegmentText({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);

    final textColor = selected ? p.text : p.text2;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
