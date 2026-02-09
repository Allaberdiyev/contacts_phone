import 'dart:ui';
import 'package:flutter/material.dart';

class RecentsSegmentedButton extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  final double width;
  final double height;

  final String leftText;
  final String rightText;

  const RecentsSegmentedButton({
    super.key,
    required this.value,
    required this.onChanged,
    this.width = 70,
    this.height = 50,
    this.leftText = "",
    this.rightText = "",
  });

  @override
  Widget build(BuildContext context) {
    final w = width;
    final h = height;

    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: w,
          height: h,
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.10),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Stack(
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
                alignment: value == 0
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: Container(
                  width: (w - 6) / 2,
                  height: h - 6,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),

              Row(
                children: [
                  _SegmentText(
                    title: leftText,
                    selected: value == 0,
                    onTap: () => onChanged(0),
                  ),
                  _SegmentText(
                    title: rightText,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final active = isDark ? Colors.white : Colors.black87;
    final inactive = isDark ? Colors.white70 : Colors.black54;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: selected ? active : inactive,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
