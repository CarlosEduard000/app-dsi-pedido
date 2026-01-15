import '../entities/article.dart';

abstract class ArticlesRepository {
  Future<List<Article>> getArticles({
    int page = 1,
    int offset = 10,
    String query = '',
    required int warehouseId,
  });

  Future<Article> getArticleById(String id);

  Future<List<Article>> searchArticleByTerm(
    String term, {
    required int warehouseId,
  });
}
