import 'package:dio/dio.dart';
import 'package:app_dsi_pedido/config/config.dart';
import '../../domain/domain.dart';
import '../mappers/client_mapper.dart';

class ClientDatasourceImpl extends ClientDatasource {
  late final Dio dio;
  final String accessToken;

  ClientDatasourceImpl({required this.accessToken})
    : dio = Dio(
        BaseOptions(
          baseUrl: Environment.apiUrl,
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

  @override
  Future<List<Client>> getClientsByVendedor(
    int idVendedor, {
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await dio.get(
        '/clients/vendedor/$idVendedor',
        queryParameters: {'page': page, 'limit': limit},
      );

      final List<dynamic> data = response.data;

      return data.map((json) => ClientMapper.jsonToEntity(json)).toList();
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
      return ClientMapper.jsonToEntity(response.data);
    } catch (e) {
      throw Exception('Error al obtener cliente: $e');
    }
  }

  @override
  Future<List<Client>> searchClients(String query, {int limit = 10}) async {
    try {
      print('BUSCANDO EN API: $query');
      final response = await dio.get(
        '/clients/search',
        queryParameters: {
          'q': query,
          'limit': limit,
        },
      );

      final List<dynamic> data = response.data;
      return data.map((json) => ClientMapper.jsonToEntity(json)).toList();
    } catch (e) {
      throw Exception('Error en búsqueda de clientes: $e');
    }
  }
}