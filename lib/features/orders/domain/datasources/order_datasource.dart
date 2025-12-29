import '../domain.dart';

abstract class OrderDatasource {
  Future<List<Order>> getOrdersByVendedor(int idVendedor, {int page = 1});
  Future<OrderSummary> getOrderSummary(int idVendedor);
}
