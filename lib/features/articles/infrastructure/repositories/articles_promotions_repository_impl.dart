import '../../articles.dart';

class ArticlesPromotionsRepositoryImpl implements ArticlesPromotionsRepository {
  final ArticlesPromotionsDatasource datasource;

  ArticlesPromotionsRepositoryImpl({required this.datasource});

  @override
  Future<GiftPromotion?> getGiftPromotionByArticleId(String articleId) {
    return datasource.getGiftPromotionByArticleId(articleId);
  }

  @override
  Future<LiquidationRule?> getLiquidationRuleByArticleId(String articleId) {
    return datasource.getLiquidationRuleByArticleId(articleId);
  }
}
