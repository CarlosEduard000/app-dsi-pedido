import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CartTabsSelector extends StatelessWidget {
  final bool isSummaryView;
  final ValueChanged<bool> onTabChanged;

  const CartTabsSelector({
    super.key,
    required this.isSummaryView,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        height: 35,
        decoration: BoxDecoration(
          color: colors.onSurface.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            _buildTab('PRODUCTOS', !isSummaryView, colors),
            _buildTab('RESUMEN', isSummaryView, colors),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String text, bool active, ColorScheme colors) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTabChanged(text == 'RESUMEN'),
        child: Container(
          margin: const EdgeInsets.all(2),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? colors.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: colors.shadow.withOpacity(0.1),
                      blurRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Text(
            text,
            style: GoogleFonts.roboto(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: active ? colors.secondary : colors.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
