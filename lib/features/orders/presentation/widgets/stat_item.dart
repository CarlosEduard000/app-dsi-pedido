import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;

  const StatItem({
    super.key,
    required this.value,
    required this.label,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: GoogleFonts.roboto(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 9,
            color: colors.onSurfaceVariant,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
