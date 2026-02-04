import 'package:flutter/material.dart';

enum IconContentType { image, text }

class IconWidget extends StatelessWidget {
  final IconContentType type;
  final Image? image;
  final String? text;
  final bool selected;
  final bool isDark;
  final VoidCallback onTap;
  final double iconSize;
  final double fontSize;
  final double radius;

  const IconWidget({
    super.key,
    required this.type,
    this.image,
    this.text,
    required this.selected,
    required this.isDark,
    required this.onTap,
    this.iconSize = 20,
    this.fontSize = 16,
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

    Widget content;
    if (type == IconContentType.image && image != null) {
      content = SizedBox(width: iconSize, height: iconSize, child: image);
    } else if (type == IconContentType.text && text != null) {
      content = Text(
        text!,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black,
        ),
      );
    } else {
      content = const SizedBox();
    }

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
            child: Center(child: content),
          ),
        ),
      ),
    );
  }
}
