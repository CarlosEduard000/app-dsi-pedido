import 'package:flutter/material.dart';
import 'package:app_dsi_pedido/features/orders/domain/domain.dart';

class OrdersList extends StatelessWidget {
  final List<Order> orders;

  const OrdersList({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (orders.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          'No hay pedidos registrados',
          style: TextStyle(color: colors.onSurfaceVariant),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final pedido = orders[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: colors.onSurface.withOpacity(0.05),
                blurRadius: 4,
              ),
            ],
            border: Border.all(color: colors.outline.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Icon(Icons.circle, color: pedido.statusColor, size: 16),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pedido.id,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        color: colors.onSurface,
                      ),
                    ),
                    Text(
                      pedido.shortClientName,
                      style: TextStyle(
                        color: colors.onSurfaceVariant,
                        fontSize: 10,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  pedido.paymentType,
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 10,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  pedido.amountFormatted,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    color: colors.secondary,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
