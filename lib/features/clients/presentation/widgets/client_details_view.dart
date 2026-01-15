import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/client.dart';

class ClientDetailsView extends StatelessWidget {
  final Client client;

  const ClientDetailsView({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildClientHeader(colors),
        const Divider(height: 40, thickness: 1),
        _buildCreditInfo(colors),
        const Divider(height: 40, thickness: 1),
      ],
    );
  }

  Widget _buildClientHeader(ColorScheme colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          client.name,
          style: GoogleFonts.roboto(
            color: colors.onSurfaceVariant,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          client.documentNumber,
          style: GoogleFonts.roboto(
            color: colors.secondary,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (client.addresses.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              client.addresses.first,
              style: TextStyle(fontSize: 12, color: colors.outline),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }

  Widget _buildCreditInfo(ColorScheme colors) {
    final credit = client.creditLines.isNotEmpty
        ? client.creditLines.first
        : null;
    String formatCurrency(double amount) => 'S/ ${amount.toStringAsFixed(2)}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.info_outline, size: 18, color: colors.primary),
            const SizedBox(width: 8),
            Text(
              'Crédito disponible',
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: colors.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Linea asignada: ${credit != null ? formatCurrency(credit.assigned) : "S/ 0.00"}',
          style: GoogleFonts.roboto(color: colors.outline, fontSize: 13),
        ),
        const SizedBox(height: 4),
        Text(
          'Linea disponible: ${credit != null ? formatCurrency(credit.available) : "S/ 0.00"}',
          style: GoogleFonts.roboto(
            color: colors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
