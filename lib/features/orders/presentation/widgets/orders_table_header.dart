import 'package:flutter/material.dart';

class OrdersTableHeader extends StatelessWidget {
  const OrdersTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // Extraemos el tema para mantener la coherencia visual
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      // Usamos los mismos márgenes horizontales que los items de la lista (10)
      // más el padding interno que tiene el contenedor (12)
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              'Estado',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isDark ? colors.onSurfaceVariant : colors.secondary,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'Cliente',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isDark ? colors.onSurfaceVariant : colors.secondary,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Cobro',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isDark ? colors.onSurfaceVariant : colors.secondary,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Importe',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isDark ? colors.onSurfaceVariant : colors.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
