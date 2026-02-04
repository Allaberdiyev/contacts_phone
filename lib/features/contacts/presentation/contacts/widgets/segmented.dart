import 'dart:ui';
import 'package:flutter/material.dart';

class Segmented extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const Segmented({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const w = 230.0;
    const h = 38.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: w,
          height: h,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.10),
            borderRadius: BorderRadius.circular(999),
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
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),

              Row(
                children: [
                  _SegmentText(title: "Details", onTap: () => onChanged(0)),
                  _SegmentText(title: "Voicemails", onTap: () => onChanged(1)),
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
  final VoidCallback onTap;

  const _SegmentText({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
