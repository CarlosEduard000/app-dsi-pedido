import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatefulWidget {
  static const name = 'welcome';
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    // 1. Obtenemos el esquema de colores del tema centralizado
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        width: screenSize.width * 0.9,
        height: 65,
        child: FloatingActionButton.extended(
          // 2. Usamos colors.primary (el Cyan definido en tu AppTheme)
          backgroundColor: colors.primary, 
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          label: Text(
            'INICIAR',
            style: GoogleFonts.exo(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white, // El texto del botón suele ser blanco sobre el color primario
              letterSpacing: 1.2,
            ),
          ),
          onPressed: () {
            context.go('/login'); 
          },
        ),
      ),
      body: Stack(
        children: [
          // Imagen de Fondo
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/fondo.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Capa de Contraste (Degradado)
          // Mantenemos el negro para asegurar legibilidad sobre la imagen
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.4, 0.9],
                  colors: [Colors.transparent, Colors.black87],
                ),
              ),
            ),
          ),

          // Logo
          Positioned(
            top: MediaQuery.of(context).padding.top + 20,
            left: 20,
            child: Image.asset(
              'assets/images/logo.png',
              height: 50,
              cacheHeight: 150,
            ),
          ),

          // Textos
          Positioned(
            bottom: 160,
            left: 25,
            right: 25,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DSI Pedidos',
                  style: GoogleFonts.exo(
                    fontSize: 42,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Toma de pedidos ágil y conectada con tu\nERP DSI-Net, desde cualquier lugar.',
                  style: GoogleFonts.exo(
                    fontSize: 18,
                    color: Colors.white.withValues(alpha:  0.8),
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}