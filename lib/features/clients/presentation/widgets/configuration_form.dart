import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

// --- IMPORTS DE CAPA SHARED (UI Global) ---
import '../../../../shared/shared.dart';

// --- IMPORTS DE AUTH (Usuario, Entidades y Data de API) ---
import '../../../auth/auth.dart';

// --- IMPORT DE CLIENTS (Providers de estado: Shop, Warehouse, Client, Payment) ---
import '../../clients.dart';


class ConfigurationForm extends ConsumerWidget {
  const ConfigurationForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    // Escuchamos la data aquí
    final establishmentsAsync = ref.watch(establishmentsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Datos a configurar',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
            fontSize: 17,
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: 20),

        // 1. Selector de Tienda
        establishmentsAsync.when(
          loading: () => const Center(child: LinearProgressIndicator()),
          error: (err, _) => Text('Error cargando tiendas: $err',
              style: TextStyle(color: colors.error)),
          data: (config) => _ShopSelector(config: config),
        ),

        const SizedBox(height: 20),

        // 2. Selector de Pago
        const _PaymentSelector(),

        const SizedBox(height: 20),

        // 3. Selector de Almacén
        establishmentsAsync.when(
          loading: () => const SizedBox(),
          error: (_, __) => const SizedBox(),
          data: (config) => _WarehouseSelector(config: config),
        ),
      ],
    );
  }
}

// -- Sub-widgets privados para ConfigurationForm --

class _ShopSelector extends ConsumerWidget {
  final SellerConfig config;
  const _ShopSelector({required this.config});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final selectedShop = ref.watch(selectedShopProvider);

    return SelectableInputField(
      value: selectedShop?.name,
      hintText: 'Seleccionar Tienda',
      icon: Icons.store_outlined,
      onPressed: () async {
        if (config.tiendas.isEmpty) {
          _showSnack(context, 'No hay tiendas disponibles');
          return;
        }

        final shop = await showSearch<Shop?>(
          context: context,
          delegate: GlobalSearchDelegate<Shop>(
            searchLabel: 'Buscar Tienda',
            initialData: config.tiendas,
            searchFunction: (query) => searchLocalShops(query, config.tiendas),
            resultBuilder: (context, item, close) {
              return ListTile(
                title: Text(item.name, style: TextStyle(color: colors.onSurface)),
                leading: Icon(Icons.store, color: colors.onSurfaceVariant),
                onTap: () => close(item),
              );
            },
          ),
        );

        if (!context.mounted) return;
        await Future.delayed(const Duration(milliseconds: 300));
        if (!context.mounted) return;

        if (shop != null) {
          ref.read(selectedShopProvider.notifier).state = shop;
        }
      },
    );
  }
}

class _PaymentSelector extends ConsumerWidget {
  const _PaymentSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final client = ref.watch(selectedClientProvider);
    final selectedPayment = ref.watch(selectedPaymentMethodProvider);

    return SelectableInputField(
      value: selectedPayment,
      hintText: 'Seleccionar forma de cobro',
      icon: Icons.payments_outlined,
      onPressed: () async {
        if (client == null) {
          _showSnack(context, 'Primero seleccione un cliente');
          return;
        }
        if (client.paymentMethods.isEmpty) {
          _showSnack(context, 'Este cliente no tiene formas de pago');
          return;
        }

        final payment = await showSearch<String?>(
          context: context,
          delegate: GlobalSearchDelegate<String>(
            searchLabel: 'Forma de cobro',
            initialData: client.paymentMethods,
            searchFunction: (query) =>
                searchLocalStrings(query, client.paymentMethods),
            resultBuilder: (context, item, close) {
              return ListTile(
                title: Text(item, style: TextStyle(color: colors.onSurface)),
                leading: Icon(Icons.payment, color: colors.onSurfaceVariant),
                onTap: () => close(item),
              );
            },
          ),
        );

        if (!context.mounted) return;
        await Future.delayed(const Duration(milliseconds: 300));
        if (!context.mounted) return;

        if (payment != null) {
          ref.read(selectedPaymentMethodProvider.notifier).state = payment;
        }
      },
    );
  }
}

class _WarehouseSelector extends ConsumerWidget {
  final SellerConfig config;
  const _WarehouseSelector({required this.config});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final selectedWarehouse = ref.watch(selectedWarehouseProvider);

    return SelectableInputField(
      value: selectedWarehouse?.name,
      hintText: 'Seleccionar Almacen',
      icon: Icons.warehouse_outlined,
      onPressed: () async {
        if (config.almacenes.isEmpty) {
          _showSnack(context, 'No hay almacenes disponibles');
          return;
        }

        final warehouse = await showSearch<Warehouse?>(
          context: context,
          delegate: GlobalSearchDelegate<Warehouse>(
            searchLabel: 'Buscar Almacén',
            initialData: config.almacenes,
            searchFunction: (query) =>
                searchLocalWarehouses(query, config.almacenes),
            resultBuilder: (context, item, close) {
              return ListTile(
                title: Text(item.name, style: TextStyle(color: colors.onSurface)),
                leading: Icon(Icons.warehouse, color: colors.onSurfaceVariant),
                onTap: () => close(item),
              );
            },
          ),
        );

        if (!context.mounted) return;
        await Future.delayed(const Duration(milliseconds: 300));
        if (!context.mounted) return;

        if (warehouse != null) {
          ref.read(selectedWarehouseProvider.notifier).state = warehouse;
        }
      },
    );
  }
}

// Helpers privados para ConfigurationForm
void _showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}