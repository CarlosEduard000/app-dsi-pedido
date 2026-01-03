import 'package:flutter/material.dart';

class OrdersTableHeader extends StatelessWidget {
  const OrdersTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
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
                color: colors.onSurfaceVariant,
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
                color: colors.onSurfaceVariant,
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
                color: colors.onSurfaceVariant,
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
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
