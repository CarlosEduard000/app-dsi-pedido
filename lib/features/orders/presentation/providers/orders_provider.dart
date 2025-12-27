import 'order_state_provider.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

final ordersProvider = StateNotifierProvider<OrdersNotifier, OrderStateProvider>((
  ref,
) {
  // 1. Obtenemos el repositorio (que ya debería estar definido en tus providers)
  // final ordersRepository = ref.watch(ordersRepositoryProvider);

  // 2. Opcional: Escuchamos el ID del vendedor desde el AuthProvider
  final user = ref.watch(authProvider).user;
  final idVendedor = user?.idVendedor ?? 0;

  return OrdersNotifier(
    // repository: ordersRepository,
    idVendedor: idVendedor,
  );
});

class OrdersNotifier extends StateNotifier<OrderStateProvider> {
  // final OrdersRepository repository;
  final int idVendedor;

  OrdersNotifier({
    // required this.repository,
    required this.idVendedor,
  }) : super(OrderStateProvider()) {
    // Cargamos los pedidos automáticamente al crear el provider
    loadOrders();
  }

  Future<void> loadOrders() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // Aquí llamarías a tu API a través del repositorio
      // final orders = await repository.getOrdersByVendedor(idVendedor);

      // Simulación de carga exitosa
      await Future.delayed(const Duration(seconds: 1));
      state = state.copyWith(
        isLoading: false,
        orders: [],
      ); // Aquí pasas los orders reales
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'No se pudieron cargar los pedidos',
      );
    }
  }
}
