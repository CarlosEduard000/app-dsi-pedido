import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'config/router/app_router.dart';
import 'shared/shared.dart';

// El main ahora es Future para permitir el await de dotenv
Future<void> main() async {
  // 1. Necesario para inicializar plugins antes de runApp
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Carga las variables de entorno antes de que cualquier provider las pida
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    // Si falla el .env, al menos la app no se muere silenciosamente
    print("Error cargando archivo .env: $e");
  }

  runApp(
    const ProviderScope(
      child: MainApp()
    )
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Estos watches ahora funcionarán porque dotenv ya está cargado
    final appRouter = ref.watch(appRouterStateProvider);
    final appTheme = ref.watch(themeNotifierProvider);

    return MaterialApp.router(
      title: 'DSI-Pedidos',
      routerConfig: appRouter,
      theme: appTheme.getTheme(),
      debugShowCheckedModeBanner: false,
      builder: (context, child) => GlobalDismissKeyboard(child: child!),
    );
  }
}