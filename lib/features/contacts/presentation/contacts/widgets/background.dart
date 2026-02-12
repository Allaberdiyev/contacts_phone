import 'package:contacts_phone/app/theme.dart';
import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: ContactDetailsTheme.backgroundColors,
          stops: ContactDetailsTheme.backgroundStops,
        ),
      ),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0, 0.25),
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Color(0x330A0814)],
          ),
        ),
      ),
    );
  }
}
