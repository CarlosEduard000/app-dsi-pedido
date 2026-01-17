import '../entities/gift_promotion.dart';
import '../entities/liquidation_rule.dart';

abstract class ArticlesPromotionsDatasource {
  
  /// Obtiene el detalle de la promoción de regalo (Escenario 1)
  /// Retorna null si no se encuentra o hay error controlado.
  Future<GiftPromotion?> getGiftPromotionByArticleId(String articleId);

  /// Obtiene el detalle de la regla de liquidación (Escenario 2)
  /// Retorna null si no se encuentra o hay error controlado.
  Future<LiquidationRule?> getLiquidationRuleByArticleId(String articleId);
}