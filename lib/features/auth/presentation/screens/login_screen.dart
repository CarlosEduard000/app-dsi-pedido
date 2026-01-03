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
  final rucController = TextEditingController();
  final userController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLastCredentials();
  }

  void _loadLastCredentials() async {
    final credentials = await ref
        .read(authProvider.notifier)
        .getLastCredentials();

    if (credentials['ruc'] != null) {
      final ruc = credentials['ruc']!;
      rucController.text = ruc;
      ref.read(loginFormProvider.notifier).onRucChange(ruc);
    }

    if (credentials['id'] != null) {
      final id = credentials['id']!;
      userController.text = id;
      ref.read(loginFormProvider.notifier).onIdChange(id);
    }
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

    final loginForm = ref.watch(loginFormProvider);
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
                          color: colors.onSurface.withOpacity(0.1),
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
                            border: Border.all(
                              color: colors.outline.withOpacity(0.2),
                            ),
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
                            color: colors.onSurfaceVariant.withOpacity(0.7),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 20),
                        CustomInputField(
                          controller: rucController,
                          hintText: 'Empresa RUC',
                          prefixIcon: Icons.badge_outlined,
                          isNumber: true,
                          showClearButton: true,
                          onChanged: ref
                              .read(loginFormProvider.notifier)
                              .onRucChange,
                          errorMessage: loginForm.isFormPosted
                              ? loginForm.ruc.errorMessage
                              : null,
                        ),
                        const SizedBox(height: 15),
                        CustomInputField(
                          controller: userController,
                          hintText: 'Usuario',
                          prefixIcon: Icons.person_outline,
                          showClearButton: true,
                          onChanged: ref
                              .read(loginFormProvider.notifier)
                              .onIdChange,
                          errorMessage: loginForm.isFormPosted
                              ? loginForm.id.errorMessage
                              : null,
                        ),
                        const SizedBox(height: 15),
                        CustomInputField(
                          controller: passwordController,
                          hintText: 'Password',
                          prefixIcon: Icons.lock_outline,
                          isPassword: true,
                          forceUpperCase: false,
                          showClearButton: true,
                          showPasswordVisibleButton: true,
                          onChanged: ref
                              .read(loginFormProvider.notifier)
                              .onPasswordChange,
                          errorMessage: loginForm.isFormPosted
                              ? loginForm.password.errorMessage
                              : null,
                        ),
                        if (authState.errorMessage.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Text(
                            authState.errorMessage,
                            style: TextStyle(color: colors.error, fontSize: 13),
                          ),
                        ],
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: loginForm.isPosting
                                ? null
                                : () {
                                    FocusScope.of(context).unfocus();
                                    ref
                                        .read(loginFormProvider.notifier)
                                        .onFormSubmit();
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              elevation: 0,
                            ),
                            child: loginForm.isPosting
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: colors.onPrimary,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Ingresar',
                                    style: GoogleFonts.roboto(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: colors.onPrimary,
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
                          onPressed: () {},
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
