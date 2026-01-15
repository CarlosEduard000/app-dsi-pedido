import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../orders/presentation/providers/order_draft_provider.dart';

class CatalogBottomBar extends ConsumerWidget {
  final FocusNode searchFocusNode;

  const CatalogBottomBar({super.key, required this.searchFocusNode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final draft = ref.watch(orderDraftProvider);

    return Container(
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: colors.surface,
        boxShadow: [
          BoxShadow(
            color: colors.onSurface.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSummaryItem(
                    'Items',
                    '${draft.totalItems}',
                    colors: colors,
                  ),
                  _buildSummaryItem(
                    'Unidades',
                    '${draft.totalUnits}',
                    colors: colors,
                  ),
                  _buildSummaryItem(
                    'Total estimado',
                    'S/ ${draft.totalAmount.toStringAsFixed(2)}',
                    isTotal: true,
                    colors: colors,
                  ),
                ],
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: draft.items.isEmpty
                      ? null
                      : () {
                          searchFocusNode.unfocus();
                          context.push('/cart_screen');
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Continuar Pedido',
                    style: GoogleFonts.roboto(
                      color: colors.secondary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
    String label,
    String value, {
    bool isTotal = false,
    required ColorScheme colors,
  }) {
    return Column(
      crossAxisAlignment: isTotal
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.roboto(
            fontSize: 10,
            color: colors.outline,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.roboto(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: isTotal ? colors.primary : colors.onSurface,
          ),
        ),
      ],
    );
  }
}
