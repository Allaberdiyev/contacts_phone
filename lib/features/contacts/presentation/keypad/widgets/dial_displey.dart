import 'package:flutter/material.dart';

class DialDisplay extends StatelessWidget {
  final double height;
  final double side;
  final String text;

  const DialDisplay({
    super.key,
    required this.height,
    required this.side,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: side),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.center,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 44,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
