import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'app_router_notifier.dart';
import '../../features/auth/auth.dart';
import '../../features/articles/articles.dart';
import '../../features/orders/orders.dart';

final appRouterStateProvider = Provider<GoRouter>((ref) {
  final goRouterNotifier = ref.watch(goRouterNotifierProvider);

  return GoRouter(
    initialLocation: '/welcome',
    refreshListenable: goRouterNotifier,
    routes: [
      // --- Pantalla de Login ---
      GoRoute(
        path: '/welcome',
        name: WelcomeScreen.name, // "welcome"
        builder: (context, state) => const WelcomeScreen(),
      ),

      // --- Pantalla de Login ---
      GoRoute(
        path: '/login',
        name: LoginScreen.name, // "login"
        builder: (context, state) => const LoginScreen(),
      ),

      // --- Pantalla de Configuración inicial (Vendedor/Cliente) ---
      GoRoute(
        path: '/article_setup',
        name: ArticleSetupScreen.name, // "article_setup_screen"
        builder: (context, state) => const ArticleSetupScreen(),
      ),

      // --- Pantalla del Catálogo de Productos ---
      GoRoute(
        path: '/article_catalog',
        name: ArticleCatalogScreen.name, // "article_catalog_screen"
        builder: (context, state) => const ArticleCatalogScreen(),
      ),

      // --- Pantalla del Carrito / Resumen del Pedido ---
      GoRoute(
        path: '/cart_screen',
        name: CartScreen.name, // "cart_screen"
        builder: (context, state) => const CartScreen(),
      ),

      GoRoute(
        path: '/list_order',
        name: ListOrderScreen.name, // "list_order_screen"
        builder: (context, state) => const ListOrderScreen(),
      ),
    ],

    // Esta parte se comento solo para inciar la app
    // Lógica de Redirección Automática
    redirect: (context, state) {
      final isGoingTo = state.matchedLocation;
      final authStatus = goRouterNotifier.authStatus;

      // 1. Mientras se verifica el token (checking), no redirigir
      if (authStatus == AuthStatus.checking) return null;

      // 2. Si NO está autenticado
      if (authStatus == AuthStatus.notAuthenticated) {
        // Si ya va al login, dejarlo ir
        if (isGoingTo == '/welcome' || isGoingTo == '/login') return null;
        // Si intenta ir a cualquier otra parte, forzar al login
        return '/welcome';
      }

      // 3. Si ESTÁ autenticado
      if (authStatus == AuthStatus.authenticated) {
        // Si está en el login o en la raíz, mandarlo a la primera pantalla útil
        if (isGoingTo == '/welcome' || isGoingTo == '/login') {
          return '/article_setup';
        }
      }

      // De lo contrario, dejar que continúe a su destino
      return null;
    },
  );
});
