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
  Future<Article> getArticleById(String id) async {
    try {
      final response = await dio.get('path');
      final article = ArticleMapper.jsonToEntity(response.data);
      return article;
    } on DioException catch (e) {
      if (e.response!.statusCode == 404) throw ArticleNotFound();
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<Article>> searchArticleByTerm(String term) async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      Article(
        id: '1',
        name: 'Alternador 12V Bosch',
        price: 450.00,
        code: 'ALT-001',
        stock: 10,
        isGift: false,
      ),
      Article(
        id: '2',
        name: 'Bateria ETNA 13',
        price: 320.00,
        code: 'BAT-002',
        stock: 5,
        isGift: false,
      ),
    ];
  }
}
