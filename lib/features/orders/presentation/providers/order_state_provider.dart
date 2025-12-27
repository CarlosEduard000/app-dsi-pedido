import '../../domain/domain.dart';

class OrderStateProvider {
  final List<Order> orders;
  final bool isLoading;
  final String? errorMessage;

  OrderStateProvider({
    this.orders = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  OrderStateProvider copyWith({
    List<Order>? orders,
    bool? isLoading,
    String? errorMessage,
  }) => OrderStateProvider(
    orders: orders ?? this.orders,
    isLoading: isLoading ?? this.isLoading,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}