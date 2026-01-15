import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/widgets/widgets.dart';
import '../providers/order_draft_provider.dart';

class BuildArticleCartList extends ConsumerWidget {
  final List<OrderItem> orderItems;

  const BuildArticleCartList({super.key, required this.orderItems});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;

    if (orderItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 80, color: colors.outline),
            const SizedBox(height: 20),
            Text(
              'Tu carrito está vacío',
              style: GoogleFonts.roboto(fontSize: 18, color: colors.outline),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: orderItems.length,
      separatorBuilder: (context, index) => const Divider(height: 30),
      itemBuilder: (context, index) {
        final item = orderItems[index];
        final article = item.article;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  article.image ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(
                        Icons.inventory_2_outlined,
                        color: colors.onSurfaceVariant,
                        size: 30,
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colors.primary,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Código: ${article.code}',
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'S/ ${article.price.toStringAsFixed(2)}',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colors.onSurface,
                        ),
                      ),
                      SizedBox(
                        width: 90,
                        child: QuantityInput(
                          initialValue: item.quantity,
                          onQuantityChanged: (newVal) {
                            ref
                                .read(orderDraftProvider.notifier)
                                .addOrUpdateItem(article, newVal);
                          },
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Subtotal: S/ ${(article.price * item.quantity).toStringAsFixed(2)}',
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        color: colors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.close, size: 20, color: colors.outline),
              onPressed: () {
                ref.read(orderDraftProvider.notifier).removeItem(article.id);
              },
            ),
          ],
        );
      },
    );
  }
}
