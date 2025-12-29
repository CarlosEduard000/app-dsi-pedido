import '../../domain/domain.dart';

class OrderSummaryMapper {
  static OrderSummary jsonToEntity(Map<String, dynamic> json) => OrderSummary(
    totalAmount: double.tryParse(json['totalAmount'].toString()) ?? 0.0,
    currency: json['currency'] ?? json['moneda'] ?? 'S/.',
    qtyAprobados: json['qtyAprobados'] ?? 0,
    qtyPicking: json['qtyPicking'] ?? 0,
    qtyDespachados: json['qtyDespachados'] ?? 0,
    qtyRechazados: json['qtyRechazados'] ?? 0,
  );
}
