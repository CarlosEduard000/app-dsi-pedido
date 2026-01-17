import '../../domain/domain.dart';

class GiftPromotionMapper {
  static GiftPromotion jsonToEntity(Map<String, dynamic> json) {
    return GiftPromotion(
      // Mapea según venga de tu API (ej: c_art o article_id)
      articleId: json['c_art']?.toString() ?? '',

      minBuyQuantity: int.tryParse(json['cant_compra']?.toString() ?? '') ?? 0,

      giftArticleId: json['c_art_regalo']?.toString() ?? '',

      giftQuantity: int.tryParse(json['cant_regalo']?.toString() ?? '') ?? 0,

      startDate:
          DateTime.tryParse(json['fec_inicio']?.toString() ?? '') ??
          DateTime.now(),

      endDate:
          DateTime.tryParse(json['fec_fin']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}
