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
    final double totalPrice = article.price * currentQuantity;
    final String symbol = (article.currency == 'USD') ? '\$' : 'S/.';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surface,
        boxShadow: [
          BoxShadow(
            color: colors.onSurface.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
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
                onPressed: currentQuantity > 0 ? onConfirm : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                  disabledBackgroundColor: colors.onSurface.withOpacity(0.12),
                  disabledForegroundColor: colors.onSurface.withOpacity(0.38),
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
