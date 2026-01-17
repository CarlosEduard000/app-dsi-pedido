class LiquidationRule {
  final String articleId;         // c_art del artículo en liquidación
  final double wholesalePrice;    // Precio mayorista (referencia)
  final double liquidationPrice;  // Precio de liquidación (oferta)
  final int minQuantity;          // Cantidad mínima para activar precio
  final int allocatedStock;       // Cantidad disponible en la empresa para liquidar
  final DateTime startDate;       // Fecha inicio
  final DateTime endDate;         // Fecha fin

  LiquidationRule({
    required this.articleId,
    required this.wholesalePrice,
    required this.liquidationPrice,
    required this.minQuantity,
    required this.allocatedStock,
    required this.startDate,
    required this.endDate,
  });

  // Helper para saber si aplica la liquidación dada una cantidad de compra
  bool appliesToQuantity(int quantity) => quantity >= minQuantity;
}