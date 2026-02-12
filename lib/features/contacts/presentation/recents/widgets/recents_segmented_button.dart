import 'dart:ui';
import 'package:contacts_phone/app/theme.dart';
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
    this.width = 220,
    this.height = 44,
    this.leftText = "",
    this.rightText = "",
  });

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);

    final w = width;
    final h = height;

    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: w,
          height: h,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: p.segmentBg,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Stack(
            children: [
              Align(
                alignment:
                    value == 0 ? Alignment.centerLeft : Alignment.centerRight,
                child: Container(
                  width: (w - 6) / 2,
                  height: h - 6,
                  decoration: BoxDecoration(
                    color: p.segmentThumb,
                    borderRadius: BorderRadius.circular(999),
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
    final p = AppColors.of(context);

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: selected ? p.segmentTextActive : p.segmentTextInactive,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
