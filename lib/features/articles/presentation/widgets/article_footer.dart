import 'package:flutter/material.dart';
import 'package:app_dsi_pedido/features/articles/domain/entities/article.dart';

class ArticleFooter extends StatelessWidget {
  final Article article;
  final ColorScheme colors;
  final bool isDark;
  final int currentQuantity;
  final VoidCallback onConfirm;

  const ArticleFooter({
    super.key,
    required this.article,
    required this.colors,
    required this.isDark,
    required this.currentQuantity,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    // Cálculo reactivo del total basado en lo que el usuario escribe
    final double totalPrice = article.price * currentQuantity;
    final String symbol = (article.currency == 'USD') ? '\$' : 'S/.';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        // Asegura que el botón no se pegue al borde inferior en iOS/Android
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "MONTO TOTAL LÍNEA",
                  style: TextStyle(
                    fontSize: 11,
                    color: colors.onSurfaceVariant,
                  ),
                ),
                Text(
                  "MONEDA: ${article.currency}",
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "$symbol ${totalPrice.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDark ? colors.primary : colors.secondary,
                ),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Confirmar Cantidad",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
