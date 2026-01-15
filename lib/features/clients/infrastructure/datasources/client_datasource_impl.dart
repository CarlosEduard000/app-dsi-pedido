import 'package:dio/dio.dart';
import '../../../../shared/infrastructure/models/api_response.dart';
import '../../domain/domain.dart';
import '../mappers/client_mapper.dart';

class ClientDatasourceImpl extends ClientDatasource {
  final Dio dio;

  ClientDatasourceImpl({required this.dio});

  @override
  Future<List<Client>> getClientsByVendedor(
    int idVendedor, {
    int page = 1,
    int offset = 10,
  }) async {
    try {
      final response = await dio.get(
        '/clients/list',
        queryParameters: {'page': page, 'offset': offset},
      );

      final apiResponse = ApiResponse<List<dynamic>>.fromJson(response.data);

      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Error al cargar clientes');
      }

      final dataList = apiResponse.data ?? [];

      return dataList.map((json) => ClientMapper.jsonToEntity(json)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      throw Exception('Error al cargar clientes: ${e.message}');
    } catch (e) {
      throw Exception('Error no controlado: $e');
    }
  }

  @override
  Future<Client> getClientById(int idCliente) async {
    try {
      final response = await dio.get('/clients/$idCliente');

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
      );

      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Error al obtener cliente');
      }

      if (apiResponse.data == null) {
        throw Exception('Cliente no encontrado');
      }

      return ClientMapper.jsonToEntity(apiResponse.data!);
    } catch (e) {
      throw Exception('Error al obtener cliente: $e');
    }
  }

  @override
  Future<List<Client>> searchClients(String query, {int offset = 10}) async {
    try {
      final Map<String, dynamic> params = {'page': 1, 'offset': offset};

      if (query.isNotEmpty) {
        final isNumeric = RegExp(r'^[0-9]+$').hasMatch(query);

        if (isNumeric) {
          params['numDoc'] = query;
        } else {
          params['nombre'] = query;
        }
      }

      final response = await dio.get('/clients/list', queryParameters: params);

      final apiResponse = ApiResponse<List<dynamic>>.fromJson(response.data);

      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Error en búsqueda');
      }

      final dataList = apiResponse.data ?? [];

      return dataList.map((json) => ClientMapper.jsonToEntity(json)).toList();
    } catch (e) {
      throw Exception('Error en búsqueda de clientes: $e');
    }
  }
}
