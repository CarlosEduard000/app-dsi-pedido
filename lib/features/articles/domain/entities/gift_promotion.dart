class GiftPromotion {
  final String articleId;        // c_art del artículo que compra
  final int minBuyQuantity;      // Cantidad que debe comprar
  final String giftArticleId;    // c_art del artículo que se regala
  final int giftQuantity;        // Cantidad a regalar
  final DateTime startDate;      // Fecha inicio
  final DateTime endDate;        // Fecha fin

  GiftPromotion({
    required this.articleId,
    required this.minBuyQuantity,
    required this.giftArticleId,
    required this.giftQuantity,
    required this.startDate,
    required this.endDate,
  });
}