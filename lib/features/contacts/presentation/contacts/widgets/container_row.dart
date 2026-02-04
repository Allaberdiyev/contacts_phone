import 'package:flutter/material.dart';

class ContainerRow extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final bool showChevron;
  final VoidCallback? onTap;

  const ContainerRow({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.showChevron = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(
      color: Colors.white.withOpacity(0.92),
      fontSize: 20,
      fontWeight: FontWeight.w600,
    );
    final subStyle = TextStyle(
      color: Colors.white.withOpacity(0.65),
      fontSize: 18,
      fontWeight: FontWeight.w500,
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 14)],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: titleStyle),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(subtitle!, style: subStyle),
                  ],
                ],
              ),
            ),
            if (showChevron)
              Icon(
                Icons.chevron_right_rounded,
                size: 28,
                color: Colors.white.withOpacity(0.55),
              ),
          ],
        ),
      ),
    );
  }
}
