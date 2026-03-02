import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:contacts_phone/app/theme.dart';

enum IconContentType { icon, image, text }

class IconWidget extends StatefulWidget {
  final IconContentType type;

  final IconData? icon;
  final Image? image;
  final String? text;

  final bool selected;
  final VoidCallback onTap;

  final double size;
  final double iconSize;
  final double fontSize;
  final double radius;

  const IconWidget({
    super.key,
    required this.type,
    this.icon,
    this.image,
    this.text,
    required this.selected,
    required this.onTap,
    this.size = 45,
    this.iconSize = 22,
    this.fontSize = 16,
    this.radius = 999,
  });

  @override
  State<IconWidget> createState() => _IconWidgetState();
}

class _IconWidgetState extends State<IconWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _press;

  @override
  void initState() {
    super.initState();
    _press = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: 1,
      value: 0,
      duration: const Duration(milliseconds: 90),
      reverseDuration: const Duration(milliseconds: 220),
    );
  }

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  void _down() => _press.animateTo(1, curve: Curves.easeOut);
  void _up() => _press.animateBack(0, curve: Curves.easeOutBack);

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final baseBg = widget.selected ? p.actionBtnBg : p.actionBtnBgDisabled;
    final baseBorder = p.actionBtnBorder;
    final baseIcon = widget.selected
        ? p.actionBtnIcon
        : p.actionBtnIconDisabled;

    Widget content;
    switch (widget.type) {
      case IconContentType.icon:
        content = Icon(widget.icon, size: widget.iconSize, color: baseIcon);
        break;
      case IconContentType.image:
        content = SizedBox(
          width: widget.iconSize,
          height: widget.iconSize,
          child: widget.image,
        );
        break;
      case IconContentType.text:
        content = Text(
          widget.text ?? '',
          style: TextStyle(
            fontSize: widget.fontSize,
            fontWeight: FontWeight.w800,
            color: baseIcon,
          ),
        );
        break;
    }

    return AnimatedBuilder(
      animation: _press,
      builder: (context, _) {
        final t = _press.value;

        final scale = 1.0 + (isDark ? 0.08 : 0.06) * t;

        final lift = (isDark ? 0.22 : 0.14) * t;

        Color liftColor(Color c, double amount) {
          final alphaVal = (amount * 255).clamp(0, 255).toInt();
          return Color.alphaBlend(Colors.white.withAlpha(alphaVal), c);
        }

        final bgTop = liftColor(baseBg, lift + (isDark ? 0.08 : 0.10));
        final bgBottom = liftColor(baseBg, lift * 0.55);

        final borderAlphaVal = ((isDark ? 0.55 : 0.35) * 255).toInt();
        final borderColor = Color.lerp(
          baseBorder,
          Colors.white.withAlpha(borderAlphaVal),
          t,
        )!;

        final glow = (widget.selected ? 1.0 : 0.0) * (0.35 + 0.35 * t);
        final glowAlphaVal = (glow * 255).clamp(0, 255).toInt();

        final topGradientAlpha = ((isDark ? 0.16 : 0.22) * 255).toInt();
        final bottomGradientAlpha = ((isDark ? 0.10 : 0.06) * 255).toInt();

        return Transform.scale(
          scale: scale,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTapDown: (_) => _down(),
              onTapUp: (_) => _up(),
              onTapCancel: () => _up(),
              onTap: widget.onTap,
              child: SizedBox(
                width: widget.size,
                height: widget.size,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(widget.radius),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [bgTop, bgBottom],
                        ),
                        borderRadius: BorderRadius.circular(widget.radius),
                        border: Border.all(color: borderColor, width: 1.0),
                        boxShadow: [
                          if (widget.selected)
                            BoxShadow(
                              blurRadius: 40,
                              offset: const Offset(0, 10),
                              color: p.navShadow.withAlpha(glowAlphaVal),
                            ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  widget.radius,
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.withAlpha(topGradientAlpha),
                                    Colors.transparent,
                                    Colors.black.withAlpha(bottomGradientAlpha),
                                  ],
                                  stops: const [0.0, 0.55, 1.0],
                                ),
                              ),
                            ),
                          ),
                          Center(child: content),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
