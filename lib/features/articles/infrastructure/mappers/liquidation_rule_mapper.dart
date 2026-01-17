import '../../domain/domain.dart';

class LiquidationRuleMapper {
  static LiquidationRule jsonToEntity(Map<String, dynamic> json) {
    return LiquidationRule(
      articleId: json['c_art']?.toString() ?? '',

      wholesalePrice:
          double.tryParse(json['precio_mayorista']?.toString() ?? '') ?? 0.0,

      liquidationPrice:
          double.tryParse(json['precio_liquidacion']?.toString() ?? '') ?? 0.0,

      minQuantity: int.tryParse(json['cant_minima']?.toString() ?? '') ?? 0,

      // Stock asignado específicamente para la promoción
      allocatedStock: int.tryParse(json['stock_promo']?.toString() ?? '') ?? 0,

      startDate:
          DateTime.tryParse(json['fec_inicio']?.toString() ?? '') ??
          DateTime.now(),

      endDate:
          DateTime.tryParse(json['fec_fin']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}
