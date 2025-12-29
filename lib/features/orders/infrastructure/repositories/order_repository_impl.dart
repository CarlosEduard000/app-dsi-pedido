import '../../domain/domain.dart';

class OrderRepositoryImpl extends OrderRepository {
  final OrderDatasource datasource;

  OrderRepositoryImpl(this.datasource);

  @override
  Future<List<Order>> getOrdersByVendedor(int idVendedor, {int page = 1}) {
    return datasource.getOrdersByVendedor(idVendedor, page: page);
  }

  @override
  Future<OrderSummary> getOrderSummary(int idVendedor) {
    return datasource.getOrderSummary(idVendedor);
  }
}
