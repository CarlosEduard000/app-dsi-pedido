import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

// --- IMPORT DE CLIENTS (Providers de estado: Shop, Warehouse, Client, Payment) ---
import '../../clients.dart';

class ContinueButton extends ConsumerWidget {
  const ContinueButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final client = ref.watch(selectedClientProvider);
    final shop = ref.watch(selectedShopProvider);
    final payment = ref.watch(selectedPaymentMethodProvider);
    final warehouse = ref.watch(selectedWarehouseProvider);

    final bool isValid = client != null &&
        shop != null &&
        payment != null &&
        warehouse != null;

    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: isValid ? () => context.go('/article_catalog') : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          disabledBackgroundColor: colors.onSurface.withOpacity(0.12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          'Continuar al Catálogo',
          style: GoogleFonts.roboto(
            color: isValid ? colors.onPrimary : colors.onSurface.withOpacity(0.3),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}