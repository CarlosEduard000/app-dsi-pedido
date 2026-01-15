import 'package:app_dsi_pedido/features/articles/domain/domain.dart';
import 'package:app_dsi_pedido/features/articles/infrastructure/errors/article_errors.dart';
import 'package:app_dsi_pedido/features/articles/infrastructure/mappers/article_mapper.dart';
import 'package:dio/dio.dart';

import '../../../../shared/infrastructure/models/api_response.dart';

class ArticlesDatasourceImpl extends ArticlesDatasource {
  final Dio dio;

  ArticlesDatasourceImpl({required this.dio});

  @override
  Future<List<Article>> getArticles({
    int page = 1,
    int offset = 10,
    String query = '',
    required int warehouseId,
  }) async {
    try {
      final Map<String, dynamic> queryParameters = {
        'page': page,
        'offset': offset,
        'c_alm': warehouseId,
      };

      if (query.isNotEmpty) {
        queryParameters['descripcion'] = query;
      }

      final response = await dio.get(
        '/articles/list',
        queryParameters: queryParameters,
      );

      final apiResponse = ApiResponse<List<dynamic>>.fromJson(response.data);

      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Error al obtener artículos');
      }

      final List<dynamic> articlesList = apiResponse.data ?? [];

      final List<Article> articles = articlesList
          .map((item) => ArticleMapper.jsonToEntity(item))
          .toList();

      return articles;
    } catch (e) {
      throw Exception('Error en getArticles: $e');
    }
  }

  @override
  Future<Article> getArticleById(String id) async {
    try {
      final response = await dio.get('/articles/$id');
      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
      );
      if (!apiResponse.success) throw Exception(apiResponse.message);
      if (apiResponse.data == null) throw ArticleNotFound();
      return ArticleMapper.jsonToEntity(apiResponse.data!);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw ArticleNotFound();
      throw Exception('Error de red: ${e.message}');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Future<List<Article>> searchArticleByTerm(
    String term, {
    required int warehouseId,
  }) async {
    try {
      final Map<String, dynamic> params = {
        'page': 1,
        'offset': 10,
        'descripcion': term,
        'c_alm': warehouseId,
      };

      final response = await dio.get('/articles/list', queryParameters: params);

      final apiResponse = ApiResponse<List<dynamic>>.fromJson(response.data);

      if (!apiResponse.success) throw Exception(apiResponse.message);

      final List<dynamic> articlesList = apiResponse.data ?? [];

      return articlesList
          .map((item) => ArticleMapper.jsonToEntity(item))
          .toList();
    } catch (e) {
      throw Exception('Error búsqueda: $e');
    }
  }
}
