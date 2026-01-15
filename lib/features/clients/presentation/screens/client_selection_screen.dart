import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/shared.dart';
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
          'Seleccionar cliente',
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
      body: const GlobalDismissKeyboard(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              
              // 1. Sección de Búsqueda de Cliente y Label de Usuario
              ClientSearchSection(),
              
              SizedBox(height: 25),

              // 2. Visualización de detalles del cliente (o placeholder)
              ClientInfoDisplay(),

              // 3. Formulario de Configuración (Tienda, Pago, Almacén)
              ConfigurationForm(),

              SizedBox(height: 45),

              // 4. Botón de Acción
              ContinueButton(),
              
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}