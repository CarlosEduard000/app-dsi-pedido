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
      // Backend: /clients/list?page=1&offset=10
      // Nota: Asumimos que el backend filtra por el vendedor del Token,
      // por eso no enviamos 'idVendedor' explícitamente en los params,
      // salvo que el backend lo exija.
      final response = await dio.get(
        '/clients/list',
        queryParameters: {
          'page': page,
          'offset': offset,
        },
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
      // Lógica de "Búsqueda Inteligente":
      // Definimos los parámetros base
      final Map<String, dynamic> params = {
        'page': 1,      // Al buscar siempre reiniciamos a la página 1
        'offset': offset
      };

      if (query.isNotEmpty) {
        // Expresión regular para saber si son SOLO números (DNI/RUC)
        final isNumeric = RegExp(r'^[0-9]+$').hasMatch(query);

        if (isNumeric) {
          // Si son números, usamos el parámetro 'numDoc'
          params['numDoc'] = query;
        } else {
          // Si tiene letras, usamos el parámetro 'nombre'
          params['nombre'] = query;
        }
      }

      final response = await dio.get(
        '/clients/list',
        queryParameters: params,
      );

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