import 'package:flutter/material.dart';

class BackspaceButton extends StatefulWidget {
  final double size;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const BackspaceButton({
    super.key,
    required this.size,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  State<BackspaceButton> createState() => _BackspaceButtonState();
}

class _BackspaceButtonState extends State<BackspaceButton> {
  bool down = false;

  @override
  Widget build(BuildContext context) {
    final w = (widget.size * 0.4);
    final h = widget.size.clamp(44.0, 58.0);

    return GestureDetector(
      onTapDown: (_) => setState(() => down = true),
      onTapCancel: () => setState(() => down = false),
      onTapUp: (_) => setState(() => down = false),
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: w,
        height: h,

        child: Icon(
          Icons.backspace_outlined,
          size: (h * 0.6),
          color: Colors.white.withOpacity(0.95),
        ),
      ),
    );
  }
}
