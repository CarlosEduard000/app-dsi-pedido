import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/shared.dart';
import '../../../auth/auth.dart';
import '../../clients.dart';

class ClientSelectionScreen extends StatelessWidget {
  static const name = 'client_selection_screen';

  const ClientSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: colors.surface,
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        backgroundColor: colors.surface,
        leading: IconButton(
          icon: Icon(Icons.menu, color: colors.onSurface),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text(
          'Modificar cliente',
          style: GoogleFonts.roboto(
            color: colors.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined, color: colors.secondary),
            onPressed: () => context.go('/cart_screen'),
          ),
        ],
      ),
      body: GlobalDismissKeyboard(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              Consumer(
                builder: (context, ref, child) {
                  return SelectableInputField(
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
                              title: Text(
                                client.name,
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: colors.onSurface,
                                ),
                              ),
                              subtitle: Text(
                                client.documentNumber,
                                style: GoogleFonts.roboto(
                                  fontSize: 12,
                                  color: colors.onSurfaceVariant,
                                ),
                              ),
                              leading: Icon(
                                Icons.person_outline,
                                color: colors.primary,
                              ),
                              onTap: () => close(client),
                            );
                          },
                        ),
                      );

                      if (!context.mounted) return;
                      FocusScope.of(context).unfocus();

                      if (client != null) {
                        ref.read(selectedClientProvider.notifier).state =
                            client;
                        ref.read(selectedPaymentMethodProvider.notifier).state =
                            null;
                      }
                    },
                  );
                },
              ),

              const SizedBox(height: 8),

              Consumer(
                builder: (context, ref, child) {
                  final user = ref.watch(authProvider).user;
                  return Text(
                    '* Clientes asignados a: ${user?.fullName ?? "Cargando..."}',
                    style: GoogleFonts.roboto(
                      color: colors.onSurfaceVariant,
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    ),
                  );
                },
              ),

              const SizedBox(height: 25),

              Consumer(
                builder: (context, ref, child) {
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
                },
              ),

              Text(
                'Datos a configurar',
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 20),

              Consumer(
                builder: (context, ref, child) {
                  final client = ref.watch(selectedClientProvider);
                  final subLabel = (client != null && client.shops.isNotEmpty)
                      ? 'Tienda actual: ${client.shops.first}'
                      : null;

                  return SelectableInputField(
                    hintText: 'Seleccionar Tienda',
                    icon: Icons.store_outlined,
                    bottomLabel: subLabel,
                    onPressed: () {},
                  );
                },
              ),

              const SizedBox(height: 20),

              Consumer(
                builder: (context, ref, child) {
                  final client = ref.watch(selectedClientProvider);
                  final selectedPayment = ref.watch(
                    selectedPaymentMethodProvider,
                  );
                  final subLabel =
                      (client != null && client.paymentMethods.isNotEmpty)
                      ? 'Cobro sugerido: ${client.paymentMethods.first}'
                      : null;

                  return SelectableInputField(
                    value: selectedPayment,
                    hintText: 'Seleccionar forma de cobro',
                    icon: Icons.payments_outlined,
                    bottomLabel: subLabel,
                    onPressed: () async {
                      if (client == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Primero busque y seleccione un cliente',
                              style: TextStyle(color: colors.onPrimary),
                            ),
                            backgroundColor: colors.secondary,
                          ),
                        );
                        return;
                      }

                      if (client.paymentMethods.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Este cliente no tiene formas de pago asignadas',
                              style: TextStyle(color: colors.onPrimary),
                            ),
                            backgroundColor: colors.secondary,
                          ),
                        );
                        return;
                      }

                      FocusScope.of(context).unfocus();
                      await Future.delayed(const Duration(milliseconds: 100));
                      if (!context.mounted) return;

                      final payment = await showSearch<String?>(
                        context: context,
                        delegate: GlobalSearchDelegate<String>(
                          searchLabel: 'Forma de cobro',
                          initialData: client.paymentMethods,
                          searchFunction: (query) =>
                              searchLocalList(query, client.paymentMethods),
                          resultBuilder: (context, item, close) {
                            return ListTile(
                              title: Text(
                                item,
                                style: TextStyle(color: colors.onSurface),
                              ),
                              leading: Icon(
                                Icons.payment,
                                color: colors.onSurfaceVariant.withOpacity(0.5),
                              ),
                              onTap: () => close(item),
                            );
                          },
                        ),
                      );

                      if (!context.mounted) return;
                      FocusScope.of(context).unfocus();

                      if (payment != null) {
                        ref.read(selectedPaymentMethodProvider.notifier).state =
                            payment;
                      }
                    },
                  );
                },
              ),

              const SizedBox(height: 20),

              Consumer(
                builder: (context, ref, child) {
                  final client = ref.watch(selectedClientProvider);
                  final subLabel =
                      (client != null && client.warehouses.isNotEmpty)
                      ? 'Almacén: ${client.warehouses.first}'
                      : null;

                  return SelectableInputField(
                    hintText: 'Seleccionar Almacen',
                    icon: Icons.warehouse_outlined,
                    bottomLabel: subLabel,
                    onPressed: () {},
                  );
                },
              ),

              const SizedBox(height: 45),

              Consumer(
                builder: (context, ref, child) {
                  final isSelected = ref.watch(selectedClientProvider) != null;
                  return SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: isSelected
                          ? () => context.go('/article_catalog')
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary,
                        disabledBackgroundColor: colors.onSurface.withOpacity(
                          0.12,
                        ),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Continuar al Catálogo',
                        style: GoogleFonts.roboto(
                          color: colors.secondary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

Future<List<String>> searchLocalList(String query, List<String> list) async {
  await Future.delayed(const Duration(milliseconds: 100));
  if (query.isEmpty) return list;
  return list
      .where((element) => element.toLowerCase().contains(query.toLowerCase()))
      .toList();
}
