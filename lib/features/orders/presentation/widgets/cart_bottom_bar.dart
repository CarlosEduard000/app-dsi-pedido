import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/order_draft_provider.dart';

class CartBottomBar extends StatelessWidget {
  final OrderDraftState draft;
  final bool isSummaryView;
  final VoidCallback onContinue;
  final VoidCallback onConfirm;

  const CartBottomBar({
    super.key,
    required this.draft,
    required this.isSummaryView,
    required this.onContinue,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final String buttonText = isSummaryView ? 'Realizar Pedido' : 'Continuar';
    final VoidCallback? buttonAction = isSummaryView
        ? (draft.items.isEmpty ? null : onConfirm)
        : onContinue;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: colors.surface,
        boxShadow: [
          BoxShadow(
            color: colors.onSurface.withOpacity(0.12),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSummaryRow(draft, colors),
            const SizedBox(height: 15),
            _buildButton(
              text: buttonText,
              onPressed: buttonAction,
              colors: colors,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(OrderDraftState draft, ColorScheme colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _stat('Items', '${draft.totalItems}', colors),
        _stat('Unidades', '${draft.totalUnits}', colors),
        _stat(
          'Total (sin IGV)',
          'S/. ${draft.totalAmount.toStringAsFixed(2)}',
          colors,
          isPrice: true,
        ),
      ],
    );
  }

  Widget _buildButton({
    required String text,
    required VoidCallback? onPressed,
    required ColorScheme colors,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Text(
          text,
          style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _stat(
    String label,
    String value,
    ColorScheme colors, {
    bool isPrice = false,
  }) {
    return Column(
      crossAxisAlignment: isPrice
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: colors.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.roboto(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colors.secondary,
          ),
        ),
      ],
    );
  }
}
