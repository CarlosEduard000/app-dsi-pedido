import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../clients/domain/entities/client.dart';
import '../../../clients/presentation/providers/providers.dart';

class ClientOrderHeader extends ConsumerWidget {
  final Client? client;

  const ClientOrderHeader({super.key, required this.client});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;

    final selectedWarehouse = ref.watch(selectedWarehouseProvider);
    final selectedShop = ref.watch(selectedShopProvider);
    final selectedPayment = ref.watch(selectedPaymentMethodProvider);

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    client?.name ?? 'CLIENTE NO SELECCIONADO',
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    client != null ? '${client!.documentNumber}' : '',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Almacen: ${selectedWarehouse?.name ?? "---"}',
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(4),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.settings, color: colors.onPrimary),
                onPressed: () => context.push('/client_selection_screen'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Divider(),
        _buildStoreInfo(colors, selectedShop?.name, selectedPayment),
        const SizedBox(height: 5),
        Text(
          '*Puedes editar los datos del cliente',
          style: GoogleFonts.roboto(
            fontSize: 10,
            color: colors.onSurfaceVariant.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildStoreInfo(
    ColorScheme colors,
    String? shopName,
    String? paymentMethod,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TIENDA',
                style: GoogleFonts.roboto(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface,
                ),
              ),
              Text(
                shopName ?? '---',
                style: GoogleFonts.roboto(
                  fontSize: 11,
                  color: colors.onSurfaceVariant,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'FORMA COBRO',
              style: GoogleFonts.roboto(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),
            Text(
              paymentMethod ?? '---',
              style: GoogleFonts.roboto(
                fontSize: 11,
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
