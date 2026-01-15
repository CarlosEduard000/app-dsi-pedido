import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../presentation.dart';

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

    return Scaffold(
      backgroundColor: colors.surface,
      body: Stack(
        children: [
          PurpleBackground(height: size.height * 0.5, color: colors.secondary),
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 60),
                const LogoHeader(),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: LoginCard(
                    rucController: rucController,
                    userController: userController,
                    passwordController: passwordController,
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
