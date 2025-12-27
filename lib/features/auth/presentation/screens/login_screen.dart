import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_provider.dart';
import '../../../../shared/shared.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const name = 'login';
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  // Controladores para capturar la información
  final rucController = TextEditingController();
  final userController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Cargamos las credenciales guardadas apenas se inicializa la pantalla
    _loadLastCredentials();
  }

  // Método para recuperar RUC e ID (MCARLOS) del almacenamiento persistente
  void _loadLastCredentials() async {
    final credentials = await ref
        .read(authProvider.notifier)
        .getLastCredentials();

    if (credentials['ruc'] != null) {
      rucController.text = credentials['ruc']!;
    }

    // CORRECCIÓN: Usamos la llave 'id' para que coincida con lo que
    // envía el AuthNotifier (que ahora guarda user.id)
    if (credentials['id'] != null) {
      userController.text = credentials['id']!;
    }

    // Si los datos se cargaron, refrescamos la UI para que se vean los textos
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    rucController.dispose();
    userController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    // Validar que los campos no estén vacíos antes de procesar
    if (rucController.text.isEmpty ||
        userController.text.isEmpty ||
        passwordController.text.isEmpty) {
      return;
    }

    final ruc = int.tryParse(rucController.text) ?? 0;

    // Llamamos al método loginUser de tu authProvider
    ref
        .read(authProvider.notifier)
        .loginUser(ruc, userController.text, passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colors = Theme.of(context).colorScheme;

    // Escuchar el estado de autenticación
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: colors.surface,
      body: Stack(
        children: [
          Container(
            height: size.height * 0.5,
            width: double.infinity,
            color: colors.secondary,
          ),

          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 60),

                Image.asset(
                  'assets/images/logo.png',
                  height: 60,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 30),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: colors.surface,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Icon(
                            Icons.person,
                            size: 80,
                            color: colors.primary,
                          ),
                        ),

                        const SizedBox(height: 15),
                        Text(
                          'Ingresa con tus\ncredenciales',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            color: colors.onSurfaceVariant.withValues(
                              alpha: 0.7,
                            ),
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Campo RUC
                        CustomInputField(
                          controller: rucController,
                          hintText: 'Empresa RUC',
                          prefixIcon: Icons.badge_outlined,
                          isNumber: true,
                          showClearButton: true,
                        ),

                        const SizedBox(height: 15),

                        // Campo Usuario (ID: MCARLOS)
                        CustomInputField(
                          controller: userController,
                          hintText: 'Usuario',
                          prefixIcon: Icons.person_outline,
                          showClearButton: true,
                        ),

                        const SizedBox(height: 15),

                        // Campo Password
                        CustomInputField(
                          controller: passwordController,
                          hintText: 'Password',
                          prefixIcon: Icons.lock_outline,
                          isPassword: true,
                          forceUpperCase: false,
                          showClearButton: true,
                          showPasswordVisibleButton: true,
                        ),

                        // Mensaje de error dinámico
                        if (authState.errorMessage.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Text(
                            authState.errorMessage,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 13,
                            ),
                          ),
                        ],

                        const SizedBox(height: 30),

                        // Botón de Ingreso
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed:
                                (authState.authStatus == AuthStatus.checking)
                                ? null
                                : _onLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              elevation: 0,
                            ),
                            child: (authState.authStatus == AuthStatus.checking)
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Ingresar',
                                    style: GoogleFonts.roboto(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 30),
                        const Divider(thickness: 0.5),
                        const SizedBox(height: 10),

                        Text(
                          '¿Perdiste tus accesos?',
                          style: TextStyle(color: colors.onSurfaceVariant),
                        ),
                        TextButton(
                          onPressed: () {
                            // Acción de soporte
                          },
                          child: Text(
                            'comunícate con DSI Soporte',
                            style: TextStyle(
                              color: colors.primary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
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
