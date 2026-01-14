import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_dsi_pedido/config/network/dio_provider.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../orders.dart';

class OrdersState {
  final List<Order> orders;
  final OrderSummary? summary;
  final bool isLoading;
  final bool isLastPage;
  final String? errorMessage;

  OrdersState({
    this.orders = const [],
    this.summary,
    this.isLoading = false,
    this.isLastPage = false,
    this.errorMessage,
  });

  OrdersState copyWith({
    List<Order>? orders,
    OrderSummary? summary,
    bool? isLoading,
    bool? isLastPage,
    String? errorMessage,
  }) => OrdersState(
    orders: orders ?? this.orders,
    summary: summary ?? this.summary,
    isLoading: isLoading ?? this.isLoading,
    isLastPage: isLastPage ?? this.isLastPage,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}

class OrdersNotifier extends StateNotifier<OrdersState> {
  final OrderRepository ordersRepository;
  final int idVendedor;

  int _currentPage = 1;
  bool _isLoadingNextPage = false;

  OrdersNotifier({required this.ordersRepository, required this.idVendedor})
    : super(OrdersState()) {
    loadOrders();
  }

  Future<void> loadOrders() async {
    if (state.isLoading) return;

    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      isLastPage: false,
    );
    _currentPage = 1;

    try {
      final results = await Future.wait([
        ordersRepository.getOrdersByVendedor(idVendedor, page: 1),
        ordersRepository.getOrderSummary(idVendedor),
      ]);

      final initialOrders = results[0] as List<Order>;
      final summary = results[1] as OrderSummary;

      state = state.copyWith(
        isLoading: false,
        orders: initialOrders,
        summary: summary,
        isLastPage: initialOrders.isEmpty,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error al cargar pedidos: $e',
      );
    }
  }

  Future<void> loadNextPage() async {
    const int pageSize = 10;

    if (state.isLoading || _isLoadingNextPage || state.isLastPage) return;

    _isLoadingNextPage = true;

    try {
      final nextPage = _currentPage + 1;

      final newOrders = await ordersRepository.getOrdersByVendedor(
        idVendedor,
        page: nextPage,
      );

      if (newOrders.isEmpty) {
        state = state.copyWith(isLastPage: true);
        _isLoadingNextPage = false;
        return;
      }

      final bool isDuplicate = state.orders.any(
        (existingOrder) => existingOrder.id == newOrders.first.id,
      );

      if (isDuplicate) {
        state = state.copyWith(isLastPage: true);
        _isLoadingNextPage = false;
        return;
      }

      _currentPage = nextPage;

      state = state.copyWith(
        orders: [...state.orders, ...newOrders],
        isLastPage: newOrders.length < pageSize,
      );
    } catch (e) {
      //
    } finally {
      _isLoadingNextPage = false;
    }
  }
}

final ordersRepositoryProvider = Provider<OrderRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final datasource = OrderDatasourceImpl(dio: dio);
  return OrdersRepositoryImpl(datasource);
});

final ordersProvider = StateNotifierProvider<OrdersNotifier, OrdersState>((
  ref,
) {
  final user = ref.watch(authProvider).user;
  final idVendedor = user?.idVendedor ?? 0;
  final ordersRepository = ref.watch(ordersRepositoryProvider);

  return OrdersNotifier(
    ordersRepository: ordersRepository,
    idVendedor: idVendedor,
  );
});
