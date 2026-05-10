import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  const AppLogo({this.size = 40, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFFDF6EE),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE6D7C0)),
      ),
      child: Center(
        child: Container(
          width: size * 0.55,
          height: size * 0.55,
          decoration: const BoxDecoration(
            color: Color(0xFF92C7FC),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}