import '../entities/article.dart';

abstract class ArticlesRepository {
  Future<Article> getArticleById(String id);
  Future<List<Article>> searchArticleByTerm(String term);
}
