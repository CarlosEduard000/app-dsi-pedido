import 'package:flutter/material.dart';

class CardHeaderIcon extends StatelessWidget {
  const CardHeaderIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: colors.surface,
        shape: BoxShape.circle,
        border: Border.all(
          color: colors.outline.withOpacity(0.2),
        ),
      ),
      child: Icon(
        Icons.person,
        size: 80,
        color: colors.primary,
      ),
    );
  }
}