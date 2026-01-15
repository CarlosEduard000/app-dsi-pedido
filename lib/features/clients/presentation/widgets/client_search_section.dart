import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

// --- IMPORTS DE CAPA SHARED (UI Global) ---
import '../../../../shared/shared.dart';

// --- IMPORTS DE AUTH (Usuario, Entidades y Data de API) ---
import '../../../auth/auth.dart';

// --- IMPORT DE CLIENTS (Providers de estado: Shop, Warehouse, Client, Payment) ---
import '../../clients.dart';

class ClientSearchSection extends ConsumerWidget {
  const ClientSearchSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final user = ref.watch(authProvider).user;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectableInputField(
          hintText: 'Buscar cliente...',
          icon: Icons.person_search_outlined,
          onPressed: () async {
            FocusScope.of(context).unfocus();
            await Future.delayed(const Duration(milliseconds: 100));
            if (!context.mounted) return;

            final client = await showSearch<Client?>(
              context: context,
              delegate: GlobalSearchDelegate<Client>(
                searchLabel: 'Buscar cliente...',
                initialData: [],
                searchFunction: ref
                    .read(searchedClientsProvider.notifier)
                    .searchClientsByQuery,
                resultBuilder: (context, client, close) {
                  return ListTile(
                    title: Text(client.name,
                        style: TextStyle(color: colors.onSurface)),
                    subtitle: Text(client.documentNumber,
                        style: TextStyle(color: colors.onSurfaceVariant)),
                    leading: Icon(Icons.person, color: colors.primary),
                    onTap: () => close(client),
                  );
                },
              ),
            );

            if (!context.mounted) return;
            await Future.delayed(const Duration(milliseconds: 300));
            if (!context.mounted) return;

            if (client != null) {
              ref.read(selectedClientProvider.notifier).state = client;

              // Lógica de auto-selección de pago
              if (client.paymentMethods.isNotEmpty) {
                ref.read(selectedPaymentMethodProvider.notifier).state =
                    client.paymentMethods.first;
              } else {
                ref.read(selectedPaymentMethodProvider.notifier).state = null;
              }
            }
          },
        ),
        const SizedBox(height: 8),
        Text(
          '* Clientes asignados a: ${user?.fullName ?? "Cargando..."}',
          style: GoogleFonts.roboto(
            color: colors.onSurfaceVariant,
            fontSize: 11,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}