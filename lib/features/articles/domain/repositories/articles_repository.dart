import '../entities/article.dart';

abstract class ArticlesRepository {
  Future<List<Article>> getArticles({int limit = 10, int offset = 0, String query = ''});
  Future<Article> getArticleById(String id);
  Future<List<Article>> searchArticleByTerm(String term);
}