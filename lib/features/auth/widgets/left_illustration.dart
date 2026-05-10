import 'package:flutter/material.dart';

class LeftIllustration extends StatelessWidget {
  const LeftIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 5,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF7FBFF),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(
          child: Image.asset('assets/images/illustration.jpg'),
        ),
      ),
    );
  }
}