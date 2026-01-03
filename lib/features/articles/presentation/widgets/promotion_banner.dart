import 'package:flutter/material.dart';

class PromotionBanner extends StatelessWidget {
  final ColorScheme colors;
  final int quantity;

  const PromotionBanner({
    super.key,
    required this.colors,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: colors.tertiary.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
        color: colors.tertiary.withOpacity(0.05),
      ),
      child: Row(
        children: [
          Text(
            quantity.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colors.tertiary,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              "PROMOCIÓN ESPECIAL ACTIVA",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
          Icon(Icons.stars, color: colors.tertiary, size: 22),
        ],
      ),
    );
  }
}
