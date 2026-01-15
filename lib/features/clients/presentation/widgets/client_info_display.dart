import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- IMPORT DE CLIENTS (Providers de estado: Shop, Warehouse, Client, Payment) ---
import '../../clients.dart';

class ClientInfoDisplay extends ConsumerWidget {
  const ClientInfoDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final selectedClient = ref.watch(selectedClientProvider);

    if (selectedClient != null) {
      return ClientDetailsView(client: selectedClient);
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(
          'Busque y seleccione un cliente para ver sus datos',
          style: TextStyle(color: colors.onSurfaceVariant),
        ),
      ),
    );
  }
}