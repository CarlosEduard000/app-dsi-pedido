import 'package:dio/dio.dart';
import 'package:app_dsi_pedido/config/config.dart';
import '../../../../shared/infrastructure/models/api_response.dart';
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
        '/orders/vendedor/',
        queryParameters: {'idVendedor': idVendedor, 'page': page, 'offset': 10},
      );

      final apiResponse = ApiResponse<List<dynamic>>.fromJson(response.data);

      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Error al cargar los pedidos');
      }

      final dataList = apiResponse.data ?? [];

      final List<Order> orders = dataList
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
      throw Exception('Error de conexión o servidor: ${e.message}');
    } catch (e) {
      throw Exception('Error no controlado al obtener pedidos: $e');
    }
  }

  @override
  Future<OrderSummary> getOrderSummary(int idVendedor) async {
    try {
      final response = await dio.get('/orders/summary/$idVendedor');

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
      );

      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Error al obtener el resumen');
      }

      if (apiResponse.data == null) {
        throw Exception('El servidor no devolvió datos para el resumen');
      }

      return OrderSummaryMapper.jsonToEntity(apiResponse.data!);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) throw Exception('Token expirado');
      throw Exception('Error de red al cargar resumen: ${e.message}');
    } catch (e) {
      throw Exception('Error interno: $e');
    }
  }
}
