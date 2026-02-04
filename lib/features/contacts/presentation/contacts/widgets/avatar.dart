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
    final hasImage = imageUrl.trim().isNotEmpty;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.22),
            blurRadius: 26,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.10),
          border: Border.all(color: Colors.white.withOpacity(0.16), width: 2),
        ),
        child: ClipOval(
          child: hasImage
              ? Image.network(imageUrl, fit: BoxFit.cover)
              : Center(
                  child: Text(
                    initials,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size * 0.42,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
