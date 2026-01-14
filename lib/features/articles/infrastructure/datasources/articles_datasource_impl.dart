import 'package:app_dsi_pedido/config/config.dart';
import 'package:app_dsi_pedido/features/articles/domain/domain.dart';
import 'package:app_dsi_pedido/features/articles/infrastructure/errors/article_errors.dart';
import 'package:app_dsi_pedido/features/articles/infrastructure/mappers/article_mapper.dart';
import 'package:dio/dio.dart';

import '../../../../shared/infrastructure/models/api_response.dart';

class ArticlesDatasourceImpl extends ArticlesDatasource {
  late final Dio dio;
  final String accessToken;

  ArticlesDatasourceImpl({required this.accessToken})
    : dio = Dio(
        BaseOptions(
          baseUrl: Environment.apiUrl,
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

  @override
  Future<List<Article>> getArticles({
    int limit = 10,
    int offset = 0,
    String query = '',
  }) async {
    try {
      final Map<String, dynamic> queryParameters = {
        'limit': limit,
        'offset': offset,
      };

      if (query.isNotEmpty) {
        queryParameters['q'] = query;
      }

      final response = await dio.get(
        '/articles',
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

      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Error al obtener el artículo');
      }

      if (apiResponse.data == null) {
        throw ArticleNotFound();
      }

      final article = ArticleMapper.jsonToEntity(apiResponse.data!);
      return article;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw ArticleNotFound();
      throw Exception('Error de red al obtener artículo: ${e.message}');
    } catch (e) {
      throw Exception('Error no controlado: $e');
    }
  }

  @override
  Future<List<Article>> searchArticleByTerm(String term) async {
    try {
      final Map<String, dynamic> params = {};
      if (term.isNotEmpty) params['q'] = term;

      final response = await dio.get('/articles', queryParameters: params);

      final apiResponse = ApiResponse<List<dynamic>>.fromJson(response.data);

      if (!apiResponse.success) {
        throw Exception(apiResponse.message ?? 'Error en la búsqueda');
      }

      final List<dynamic> articlesList = apiResponse.data ?? [];

      final List<Article> articles = articlesList
          .map((item) => ArticleMapper.jsonToEntity(item))
          .toList();

      return articles;
    } catch (e) {
      throw Exception('Error al buscar artículos: $e');
    }
  }
}
