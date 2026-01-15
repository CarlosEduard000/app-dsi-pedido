import '../../domain/domain.dart';

class OrdersRepositoryImpl extends OrderRepository {
  final OrderDatasource datasource;

  OrdersRepositoryImpl(this.datasource);

  @override
  Future<List<Order>> getOrdersByVendedor(int idVendedor, {int page = 1}) {
    return datasource.getOrdersByVendedor(idVendedor, page: page);
  }

  @override
  Future<OrderSummary> getOrderSummary(int idVendedor) {
    return datasource.getOrderSummary(idVendedor);
  }
}
