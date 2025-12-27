import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSelectableCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String label;
  final String? imagePath;
  final bool isSelected;
  final bool isAlertStyle; // Reemplaza la lógica de 'isGift'
  final VoidCallback onTap;
  final IconData? fallbackIcon;

  const CustomSelectableCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.label,
    this.imagePath,
    required this.isSelected,
    this.isAlertStyle = false,
    required this.onTap,
    this.fallbackIcon = Icons.image,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Color de acento basado en si es estilo alerta (gift) o normal
    final Color colorAccent = isAlertStyle ? colors.error : colors.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? colorAccent : Colors.transparent, 
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Sección de Imagen / Icono
                SizedBox(
                  width: 70,
                  height: 70,
                  child: Center(
                    child: AnimatedScale(
                      scale: isSelected ? 1.1 : 1.0,
                      duration: const Duration(milliseconds: 250),
                      child: _buildLeadingWidget(colorAccent),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                
                // Sección de Textos
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: colors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: colorAccent,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Sección de Label (Cantidad/Número)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    label,
                    style: GoogleFonts.roboto(
                      fontSize: 22,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: colors.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Método privado para decidir qué mostrar en el leading (Imagen o Icono)
  Widget _buildLeadingWidget(Color colorAccent) {
    if (isAlertStyle) {
      return Icon(Icons.card_giftcard, color: colorAccent, size: 35);
    }
    
    if (imagePath != null && imagePath!.isNotEmpty) {
      return Image.asset(imagePath!, fit: BoxFit.contain);
    }

    return Icon(
      fallbackIcon, 
      color: isSelected ? colorAccent : Colors.grey, 
      size: 40,
    );
  }
}