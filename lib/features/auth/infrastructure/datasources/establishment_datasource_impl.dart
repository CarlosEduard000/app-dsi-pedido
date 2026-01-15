import 'package:dio/dio.dart';
import '../../../../shared/infrastructure/models/api_response.dart';
import '../../domain/domain.dart';
import '../mappers/shops_warehouses_mapper.dart';

class EstablishmentDatasourceImpl extends EstablishmentDatasource {
  final Dio dio;

  EstablishmentDatasourceImpl({required this.dio});

  @override
  Future<SellerConfig> getTiendasYAlmacenes() async {
    try {
      final response = await dio.get('/vendedor/tiendas-almancenes');

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
      );

      if (!apiResponse.success) {
        throw Exception(
          apiResponse.message ?? 'Error al obtener configuración de tiendas',
        );
      }

      if (apiResponse.data == null) {
        throw Exception('No se recibieron datos de tiendas y almacenes');
      }

      return ShopsWarehousesMapper.jsonToEntity(apiResponse.data!);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Sesión expirada');
      }
      throw Exception('Error de conexión al obtener tiendas: ${e.message}');
    } catch (e) {
      throw Exception('Error no controlado: $e');
    }
  }
}
