import 'package:app_dsi_pedido/features/articles/domain/domain.dart';

class ArticlesRepositoryImpl extends ArticlesRepository {
  final ArticlesDatasource datasource;

  ArticlesRepositoryImpl(this.datasource);

  @override
  Future<Article> getArticleById(String id) {
    return datasource.getArticleById(id);
  }

  @override
  Future<List<Article>> searchArticleByTerm(String term) {
    return datasource.searchArticleByTerm(term);
  }
}
