import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class Segmented extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const Segmented({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const w = 230.0;
    const h = 38.0;

    final bg = Colors.white.withAlpha(300);
    final selectedBg = Colors.white.withAlpha(300);
    final border = Colors.white.withAlpha(5);

    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: w,
          height: h,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: border, width: 1),
          ),
          child: Stack(
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                alignment: value == 0
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: Container(
                  width: (w - 6) / 2,
                  height: h - 6,
                  decoration: BoxDecoration(
                    color: selectedBg,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              Row(
                children: [
                  _SegmentText(
                    title: "details".tr(),
                    selected: value == 0,
                    onTap: () => onChanged(0),
                  ),
                  _SegmentText(
                    title: "voicemails".tr(),
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
    final textColor = selected ? Colors.white : Colors.white.withAlpha(1200);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
              fontFamily: 'Roboto',
            ),
            child: Text(title),
          ),
        ),
      ),
    );
  }
}
