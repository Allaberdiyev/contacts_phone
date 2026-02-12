import 'package:flutter/material.dart';
import 'package:contacts_phone/app/theme.dart';

class DialKey extends StatefulWidget {
  final double diameter;
  final double titleSize;
  final double subSize;
  final String title;
  final String sub;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const DialKey({
    super.key,
    required this.diameter,
    required this.titleSize,
    required this.subSize,
    required this.title,
    required this.sub,
    required this.onTap,
    this.onLongPress,
  });

  @override
  State<DialKey> createState() => _DialKeyState();
}

class _DialKeyState extends State<DialKey> {
  bool down = false;

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);
    final showSub = widget.sub.isNotEmpty;

    final bg = down ? p.keypadHi : p.keypadFill;
    final border = p.keypadBorder;

    return GestureDetector(
      onTapDown: (_) => setState(() => down = true),
      onTapCancel: () => setState(() => down = false),
      onTapUp: (_) => setState(() => down = false),
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: Container(
        width: widget.diameter,
        height: widget.diameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bg,
          border: Border.all(color: border),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  color: p.text,
                  fontSize: widget.titleSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (showSub)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    widget.sub,
                    style: TextStyle(
                      color: p.text2,
                      fontSize: widget.subSize,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
