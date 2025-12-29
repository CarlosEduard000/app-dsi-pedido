import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../presentation.dart';
import '../../../../shared/shared.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const name = 'login';
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  // Mantenemos los controladores SOLO para inicializar el texto visualmente
  // cuando cargamos las credenciales guardadas.
  final rucController = TextEditingController();
  final userController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLastCredentials();
  }

  void _loadLastCredentials() async {
    final credentials = await ref.read(authProvider.notifier).getLastCredentials();

    // 1. Cargar RUC
    if (credentials['ruc'] != null) {
      final ruc = credentials['ruc']!;
      rucController.text = ruc; // Actualiza la vista (Controller)
      // Actualiza el estado lógico (Riverpod + Formz)
      ref.read(loginFormProvider.notifier).onRucChange(ruc);
    }

    // 2. Cargar ID (Usuario)
    if (credentials['id'] != null) {
      final id = credentials['id']!;
      userController.text = id; // Actualiza la vista
      ref.read(loginFormProvider.notifier).onIdChange(id); // Actualiza lógica
    }
    
    // No hace falta setState aquí porque el provider se encargará de reconstruir si es necesario
  }

  @override
  void dispose() {
    rucController.dispose();
    userController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colors = Theme.of(context).colorScheme;

    // Escuchamos el estado del formulario (validaciones, loading)
    final loginForm = ref.watch(loginFormProvider);
    
    // Escuchamos el authProvider solo para errores de autenticación (backend)
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

                        // --- Campo RUC ---
                        CustomInputField(
                          controller: rucController,
                          hintText: 'Empresa RUC',
                          prefixIcon: Icons.badge_outlined,
                          isNumber: true,
                          showClearButton: true,
                          // Conectamos Riverpod
                          onChanged: ref.read(loginFormProvider.notifier).onRucChange,
                          // Mostramos error solo si el formulario ha sido enviado/tocado
                          errorMessage: loginForm.isFormPosted 
                              ? loginForm.ruc.errorMessage 
                              : null,
                        ),

                        const SizedBox(height: 15),

                        // --- Campo Usuario (ID) ---
                        CustomInputField(
                          controller: userController,
                          hintText: 'Usuario',
                          prefixIcon: Icons.person_outline,
                          showClearButton: true,
                          // Conectamos Riverpod
                          onChanged: ref.read(loginFormProvider.notifier).onIdChange,
                          errorMessage: loginForm.isFormPosted 
                              ? loginForm.id.errorMessage 
                              : null,
                        ),

                        const SizedBox(height: 15),

                        // --- Campo Password ---
                        CustomInputField(
                          controller: passwordController,
                          hintText: 'Password',
                          prefixIcon: Icons.lock_outline,
                          isPassword: true,
                          forceUpperCase: false,
                          showClearButton: true,
                          showPasswordVisibleButton: true,
                          // Conectamos Riverpod
                          onChanged: ref.read(loginFormProvider.notifier).onPasswordChange,
                          errorMessage: loginForm.isFormPosted 
                              ? loginForm.password.errorMessage 
                              : null,
                        ),

                        // Mensaje de error dinámico (Backend)
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
                            // Deshabilitamos si está posteando
                            onPressed: loginForm.isPosting
                                ? null
                                : () {
                                    // Ocultar teclado
                                    FocusScope.of(context).unfocus();
                                    // Llamar al submit del provider
                                    ref.read(loginFormProvider.notifier).onFormSubmit();
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              elevation: 0,
                            ),
                            child: loginForm.isPosting
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