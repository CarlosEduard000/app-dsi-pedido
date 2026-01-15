import '../entities/article.dart';

abstract class ArticlesRepository {
  Future<List<Article>> getArticles({
    int page = 1,
    int offset = 10,
    String query = '',
  });

  Future<Article> getArticleById(String id);

  Future<List<Article>> searchArticleByTerm(String term);
}
