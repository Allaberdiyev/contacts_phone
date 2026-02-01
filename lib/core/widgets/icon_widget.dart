import 'package:flutter/material.dart';

class IconWidget extends StatelessWidget {
  final Image imege;
  final bool selected;
  final bool isDark;
  final VoidCallback onTap;
  final double iconSize;
  final double fontSize;
  final double radius;

  const IconWidget({
    super.key,
    required this.imege,
    required this.selected,
    required this.isDark,
    required this.onTap,
    this.iconSize = 20,
    this.fontSize = 100,
    this.radius = 50,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor = selected
        ? (isDark ? Colors.white.withAlpha(30) : Colors.black.withAlpha(20))
        : Colors.transparent;

    final List<BoxShadow> shadow = selected
        ? [
            BoxShadow(
              blurRadius: 100,
              spreadRadius: 0,
              offset: const Offset(0, 6),
              color: Colors.black.withAlpha(isDark ? 90 : 35),
            ),
          ]
        : const [];

    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: 45,
        height: 45,
        child: InkWell(
          borderRadius: BorderRadius.circular(radius),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(radius),
              boxShadow: shadow,
              
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [imege],
            ),
          ),
        ),
      ),
    );
  }
}
