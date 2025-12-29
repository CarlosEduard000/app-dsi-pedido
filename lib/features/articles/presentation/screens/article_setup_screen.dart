import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/shared.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ArticleSetupScreen extends ConsumerWidget {
  static const name = 'article_setup';
  const ArticleSetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldKey = GlobalKey<ScaffoldState>();

    // Leemos el usuario para el subtítulo informativo
    final user = ref.watch(authProvider).user;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: colors.surface,
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: isDark ? Colors.white : const Color(0xFF333333)),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Búsqueda de Cliente con CustomInputField ---
            CustomInputField(
              hintText: 'Seleccionar cliente',
              prefixIcon: Icons.person_search_outlined,
              isSearchStyle: true,
              onChanged: (value) {
                // TODO: Implementar búsqueda de cliente
              },
            ),
            const SizedBox(height: 8),
            Text(
              '* Clientes asignados a: ${user?.fullName ?? "Cargando..."}',
              style: GoogleFonts.roboto(
                color: Colors.grey, 
                fontSize: 11, 
                fontStyle: FontStyle.italic
              ),
            ),
            const SizedBox(height: 25),
            
            _buildClientHeader(colors, isDark),
            
            const Divider(height: 40, thickness: 1),

            _buildCreditInfo(colors, isDark),
            
            const Divider(height: 40, thickness: 1),

            Text(
              'Datos a configurar',
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold, 
                fontSize: 17, 
                color: isDark ? Colors.white : Colors.black87
              ),
            ),
            const SizedBox(height: 20),

            // --- Selección de Tienda ---
            CustomInputField(
              hintText: 'Seleccionar Tienda',
              prefixIcon: Icons.store_outlined,
              isSearchStyle: true,
              onFocus: () {
                // TODO: Abrir selector de tiendas
              },
            ),
            _buildSubLabel('Tienda: AV. CHIMPU OCLLO 741 - COMAS, LIMA'),
            const SizedBox(height: 20),

            // --- Selección de Forma de Cobro ---
            CustomInputField(
              hintText: 'Seleccionar forma de cobro',
              prefixIcon: Icons.payments_outlined,
              isSearchStyle: true,
            ),
            _buildSubLabel('Forma de cobro: CONTADO EFECTIVO'),
            const SizedBox(height: 20),

            // --- Selección de Almacén ---
            CustomInputField(
              hintText: 'Seleccionar Almacen',
              prefixIcon: Icons.warehouse_outlined,
              isSearchStyle: true,
            ),
            _buildSubLabel('Almacen: Chimpu Ocllo'),
            
            const SizedBox(height: 45),

            // --- Botón de Acción Principal ---
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () => context.go('/article_catalog'), 
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  'CONTINUAR AL CATÁLOGO',
                  style: GoogleFonts.roboto(
                    color: Colors.white, 
                    fontSize: 16, 
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- Widgets de Apoyo ---

  Widget _buildClientHeader(ColorScheme colors, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'INVERSIONES LA PASCANA S.A.C',
          style: GoogleFonts.roboto(
            color: isDark ? Colors.white70 : const Color(0xFF455A64),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          '20503225923',
          style: GoogleFonts.roboto(
            color: colors.secondary,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCreditInfo(ColorScheme colors, bool isDark) {
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
                color: isDark ? Colors.white : Colors.black87
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Linea asignada: S/ 100.000.00',
          style: GoogleFonts.roboto(color: Colors.grey, fontSize: 13),
        ),
        const SizedBox(height: 4),
        Text(
          'Linea disponible: S/ 10.000.00',
          style: GoogleFonts.roboto(
            color: colors.primary, 
            fontWeight: FontWeight.bold, 
            fontSize: 15
          ),
        ),
      ],
    );
  }

  Widget _buildSubLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 4),
      child: Text(
        text,
        style: GoogleFonts.roboto(
          color: Colors.grey.shade500, 
          fontSize: 12,
          fontStyle: FontStyle.italic
        ),
      ),
    );
  }
}