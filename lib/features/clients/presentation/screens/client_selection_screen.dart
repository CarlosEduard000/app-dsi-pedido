import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/shared.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../clients.dart';
// Importamos el delegate y los providers necesarios
import '../delegates/search_client_delegate.dart';
// import '../providers/providers.dart';

class ClientSelectionScreen extends StatelessWidget {
  static const name = 'client_selection_screen';

  const ClientSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: colors.surface,
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        backgroundColor: colors.surface,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: isDark ? Colors.white : const Color(0xFF333333),
          ),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text(
          'Modificar cliente',
          style: GoogleFonts.roboto(
            color: isDark ? Colors.white : const Color(0xFF333333),
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

              // -------------------------------------------------------
              // 1. INPUT QUE DISPARA EL SEARCH DELEGATE (Estilo Cinemapedia)
              // -------------------------------------------------------
              Consumer(
                builder: (context, ref, child) {
                  return GestureDetector(
                    onTap: () {
                      // Preparamos los datos para el delegate
                      // final searchedClients = ref.read(searchedClientsProvider);
                      // final searchQuery = ref.read(searchQueryProvider);

                      // Lanzamos la búsqueda modal
                      showSearch<Client?>(
                        context: context,
                        // query: searchQuery,
                        delegate: SearchClientDelegate(
                          initialClients: [], //searchedClients,
                          searchClients: ref
                              .read(searchedClientsProvider.notifier)
                              .searchClientsByQuery,
                        ),
                      ).then((client) {
                        // Al volver, si seleccionó un cliente, actualizamos el estado
                        if (client != null) {
                          ref.read(selectedClientProvider.notifier).state = client;
                        }
                      });
                    },
                    // Usamos AbsorbPointer para que el CustomInputField sea solo visual
                    // y no intente abrir el teclado nativo aquí.
                    child: AbsorbPointer(
                      child: CustomInputField(
                        hintText: 'Buscar cliente...',
                        prefixIcon: Icons.person_search_outlined,
                        isSearchStyle: true,
                        // No pasamos controller ni focusNode porque es un "botón" visual
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 8),

              // Nombre del usuario logueado
              Consumer(
                builder: (context, ref, child) {
                  final user = ref.watch(authProvider).user;
                  return Text(
                    '* Clientes asignados a: ${user?.fullName ?? "Cargando..."}',
                    style: GoogleFonts.roboto(
                      color: Colors.grey,
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    ),
                  );
                },
              ),

              const SizedBox(height: 25),

              // 2. Sección de detalles reactiva
              Consumer(
                builder: (context, ref, child) {
                  final selectedClient = ref.watch(selectedClientProvider);
                  if (selectedClient != null) {
                    return ClientDetailsView(client: selectedClient);
                  }
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        'Busque y seleccione un cliente para ver sus datos',
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
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              // 3. Inputs de configuración con labels reactivos
              CustomInputField(
                hintText: 'Seleccionar Tienda',
                prefixIcon: Icons.store_outlined,
                isSearchStyle: true,
              ),
              Consumer(
                builder: (context, ref, child) {
                  final client = ref.watch(selectedClientProvider);
                  if (client == null || client.shops.isEmpty)
                    return const SizedBox();
                  return _SubLabel(
                      text: 'Tienda actual: ${client.shops.first}');
                },
              ),

              const SizedBox(height: 20),

              CustomInputField(
                hintText: 'Seleccionar forma de cobro',
                prefixIcon: Icons.payments_outlined,
                isSearchStyle: true,
              ),
              Consumer(
                builder: (context, ref, child) {
                  final client = ref.watch(selectedClientProvider);
                  if (client == null || client.paymentMethods.isEmpty)
                    return const SizedBox();
                  return _SubLabel(
                    text: 'Cobro sugerido: ${client.paymentMethods.first}',
                  );
                },
              ),

              const SizedBox(height: 20),

              CustomInputField(
                hintText: 'Seleccionar Almacen',
                prefixIcon: Icons.warehouse_outlined,
                isSearchStyle: true,
              ),
              Consumer(
                builder: (context, ref, child) {
                  final client = ref.watch(selectedClientProvider);
                  if (client == null || client.warehouses.isEmpty)
                    return const SizedBox();
                  return _SubLabel(
                      text: 'Almacén: ${client.warehouses.first}');
                },
              ),

              const SizedBox(height: 45),

              // 4. Botón de continuación reactivo
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
                        disabledBackgroundColor:
                            colors.primary.withOpacity(0.3),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'CONTINUAR AL CATÁLOGO',
                        style: GoogleFonts.roboto(
                          color: Colors.white,
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

class _SubLabel extends StatelessWidget {
  final String text;
  const _SubLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 4),
      child: Text(
        text,
        style: GoogleFonts.roboto(
          color: Colors.grey.shade500,
          fontSize: 12,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}