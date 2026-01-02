import 'package:app_dsi_pedido/features/articles/domain/domain.dart';

class ArticlesRepositoryImpl extends ArticlesRepository {
  final ArticlesDatasource datasource;

  ArticlesRepositoryImpl(this.datasource);

  @override
  Future<List<Article>> getArticles({int limit = 10, int offset = 0, String query = ''}) {
    return datasource.getArticles(limit: limit, offset: offset, query: query);
  }

  @override
  Future<Article> getArticleById(String id) {
    return datasource.getArticleById(id);
  }

  @override
  Future<List<Article>> searchArticleByTerm(String term) {
    return datasource.searchArticleByTerm(term);
  }
}