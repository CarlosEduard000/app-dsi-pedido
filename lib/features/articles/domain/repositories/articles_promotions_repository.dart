import '../entities/gift_promotion.dart';
import '../entities/liquidation_rule.dart';

abstract class ArticlesPromotionsRepository {
  
  Future<GiftPromotion?> getGiftPromotionByArticleId(String articleId);

  Future<LiquidationRule?> getLiquidationRuleByArticleId(String articleId);
}