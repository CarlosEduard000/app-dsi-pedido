import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/clients/clients.dart';
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
      GoRoute(
        path: '/welcome',
        name: WelcomeScreen.name,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/login',
        name: LoginScreen.name,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/client_selection_screen',
        name: ClientSelectionScreen.name,
        builder: (context, state) => const ClientSelectionScreen(),
      ),
      GoRoute(
        path: '/article_catalog',
        name: ArticleCatalogScreen.name,
        builder: (context, state) => const ArticleCatalogScreen(),
      ),
      GoRoute(
        path: '/cart_screen',
        name: CartScreen.name,
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: '/list_order',
        name: ListOrderScreen.name,
        builder: (context, state) => const ListOrderScreen(),
      ),
    ],
    redirect: (context, state) {
      final isGoingTo = state.matchedLocation;
      final authStatus = goRouterNotifier.authStatus;

      if (authStatus == AuthStatus.checking) return null;

      if (authStatus == AuthStatus.notAuthenticated) {
        if (isGoingTo == '/welcome' || isGoingTo == '/login') return null;
        return '/welcome';
      }

      if (authStatus == AuthStatus.authenticated) {
        if (isGoingTo == '/welcome' || isGoingTo == '/login') {
          return '/client_selection_screen';
        }
      }

      return null;
    },
  );
});
