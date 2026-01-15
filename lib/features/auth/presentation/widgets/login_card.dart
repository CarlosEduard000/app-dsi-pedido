import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/shared.dart';
import '../providers/providers.dart';
import 'card_header_icon.dart';

class LoginCard extends ConsumerWidget {
  final TextEditingController rucController;
  final TextEditingController userController;
  final TextEditingController passwordController;

  const LoginCard({
    super.key,
    required this.rucController,
    required this.userController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final loginForm = ref.watch(loginFormProvider);
    final authState = ref.watch(authProvider);

    return Container(
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
          const CardHeaderIcon(),
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
            onChanged: ref.read(loginFormProvider.notifier).onRucChange,
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
            onChanged: ref.read(loginFormProvider.notifier).onIdChange,
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
            onChanged: ref.read(loginFormProvider.notifier).onPasswordChange,
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
    );
  }
}
