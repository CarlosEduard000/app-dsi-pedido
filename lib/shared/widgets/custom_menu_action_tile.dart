import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomMenuActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
  final bool isSelected;

  const CustomMenuActionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon, 
              color: isSelected ? colors.primary : (color ?? colors.onSurface), 
              size: 22
            ),
            const SizedBox(width: 15),
            Text(
              label,
              style: GoogleFonts.roboto(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 15,
                color: isSelected ? colors.primary : (color ?? colors.onSurface),
              ),
            ),
          ],
        ),
      ),
    );
  }
}