import 'package:flutter/material.dart';

class StatusPill extends StatelessWidget {
  final String text;

  const StatusPill({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    Color bg = Colors.green.shade50;
    Color fg = Colors.green.shade700;

    if (text.contains('ملغ')) {
      bg = Colors.red.shade50;
      fg = Colors.red.shade700;
    }

    if (text.contains('معلق')) {
      bg = Colors.orange.shade50;
      fg = Colors.orange.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: fg,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}