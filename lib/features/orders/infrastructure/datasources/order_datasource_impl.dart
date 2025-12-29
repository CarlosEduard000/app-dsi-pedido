import 'package:dio/dio.dart';
import 'package:app_dsi_pedido/config/config.dart';
import '../../domain/domain.dart';
import '../infrastructure.dart';

class OrderDatasourceImpl extends OrderDatasource {
  late final Dio dio;
  final String accessToken;

  OrderDatasourceImpl({required this.accessToken})
    : dio = Dio(
        BaseOptions(
          baseUrl: Environment.apiUrl,
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

  @override
  Future<List<Order>> getOrdersByVendedor(
    int idVendedor, {
    int page = 1,
  }) async {
    try {
      final response = await dio.get(
        '/orders/vendedor/$idVendedor',
        queryParameters: {
          'page': page,
          'limit': 10, // Parámetro añadido para corregir la paginación
        },
      );

      final List<dynamic> data = response.data;

      final List<Order> orders = data
          .map((json) => OrderMapper.jsonToEntity(json))
          .toList();

      return orders;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Token inválido o expirado');
      }
      if (e.response?.statusCode == 404) {
        return [];
      }
      throw Exception('Error al cargar pedidos: ${e.message}');
    } catch (e) {
      throw Exception('Error no controlado: $e');
    }
  }

  @override
  Future<OrderSummary> getOrderSummary(int idVendedor) async {
    try {
      final response = await dio.get('/orders/summary/$idVendedor');
      return OrderSummaryMapper.jsonToEntity(response.data);
    } catch (e) {
      throw Exception('Error al cargar resumen: $e');
    }
  }
}
