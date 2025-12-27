import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomGridCard extends StatelessWidget {
  final String title;
  final String mainLabel;     // Antes: precio
  final String? topStartText;  // Antes: código
  final String? bottomEndText; // Antes: stock
  final String? imagePath;
  final bool isSelected;
  final bool hasBadge;         // Antes: isGift (estrella)
  final VoidCallback onTap;

  const CustomGridCard({
    super.key,
    required this.title,
    required this.mainLabel,
    this.topStartText,
    this.bottomEndText,
    this.imagePath,
    required this.isSelected,
    this.hasBadge = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? colors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Card(
          elevation: isSelected ? 4 : 2,
          margin: EdgeInsets.zero,
          color: isSelected
              ? (isDark ? colors.surface : Colors.white)
              : (isDark ? colors.surfaceVariant.withOpacity(0.2) : colors.surface),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Column(
            children: [
              // Área Visual Superior
              Expanded(
                child: Stack(
                  children: [
                    Center(
                      child: AnimatedScale(
                        scale: isSelected ? 1.08 : 1.0,
                        duration: const Duration(milliseconds: 250),
                        child: imagePath != null && imagePath!.isNotEmpty
                            ? Image.asset(imagePath!, width: 100, fit: BoxFit.contain)
                            : const Icon(Icons.image, size: 50, color: Colors.grey),
                      ),
                    ),
                    if (topStartText != null && topStartText!.isNotEmpty)
                      Positioned(
                        top: 5,
                        left: 10,
                        child: Text(
                          topStartText!,
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: isSelected ? colors.primary : colors.onSurface,
                          ),
                        ),
                      ),
                    if (hasBadge)
                      Positioned(
                        top: 5,
                        right: 5,
                        child: Icon(Icons.stars, color: colors.error, size: 18),
                      ),
                  ],
                ),
              ),
              
              // Área de Información Inferior
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.roboto(
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          mainLabel,
                          style: GoogleFonts.roboto(
                            color: colors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        if (bottomEndText != null)
                          Text(
                            bottomEndText!,
                            style: GoogleFonts.roboto(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}