import 'package:app_dsi_pedido/config/config.dart';
import 'package:app_dsi_pedido/features/articles/domain/domain.dart';
import 'package:app_dsi_pedido/features/articles/infrastructure/errors/article_errors.dart';
import 'package:app_dsi_pedido/features/articles/infrastructure/mappers/article_mapper.dart';
import 'package:dio/dio.dart';

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

      final List<Article> articles = [];
      for (final item in response.data) {
        articles.add(ArticleMapper.jsonToEntity(item));
      }

      return articles;
    } catch (e) {
      print('Error en getArticles: $e');
      throw Exception();
    }
  }

  @override
  Future<Article> getArticleById(String id) async {
    try {
      final response = await dio.get('/articles/$id');
      final article = ArticleMapper.jsonToEntity(response.data);
      return article;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) throw ArticleNotFound();
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<Article>> searchArticleByTerm(String term) async {
    try {
      final Map<String, dynamic> params = {};
      if (term.isNotEmpty) params['q'] = term;

      final response = await dio.get('/articles', queryParameters: params);

      final List<Article> articles = [];
      for (final item in response.data) {
        articles.add(ArticleMapper.jsonToEntity(item));
      }

      return articles;
    } catch (e) {
      throw Exception();
    }
  }
}
