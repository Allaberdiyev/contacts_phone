import 'package:contacts_phone/app/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final double size;
  final String initials;
  final String imageUrl;

  const Avatar({
    super.key,
    required this.size,
    required this.initials,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          imageUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _fallback(context),
        ),
      );
    }
    return _fallback(context);
  }

  Widget _fallback(BuildContext context) {
    final p = AppColors.of(context);

    final color1 = ContactDetailsTheme.backgroundColors[1];
    final color2 = ContactDetailsTheme.backgroundColors[3];

    return SizedBox(
      width: size,
      height: size,
      child: ClipOval(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color1, color2],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(-0.55, -0.6),
                  radius: 1.1,
                  colors: [p.avatarHighlight, p.transparent],
                ),
              ),
            ),
            Center(
              child: Text(
                initials.isEmpty ? ' ' : initials,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: size * 0.36,
                  color: p.text,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
