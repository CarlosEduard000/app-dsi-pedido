import '../entities/article.dart';

abstract class ArticlesDatasource {
  Future<Article> getArticleById(String id);
  Future<List<Article>> searchArticleByTerm(String term);
}
