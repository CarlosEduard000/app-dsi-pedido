import '../../domain/domain.dart';

class OrderSummaryMapper {
  static OrderSummary jsonToEntity(Map<String, dynamic> json) => OrderSummary(
    totalAmount: double.tryParse(json['montoTotal'].toString()) ?? 0.0,
    currency: json['currency'] ?? json['moneda'] ?? 'S/.',
    qtyAprobados: json['aprobados'] ?? 0,
    qtyPicking: json['picking'] ?? 0,
    qtyDespachados: json['despachados'] ?? 0,
    qtyRechazados: json['rechazados'] ?? 0,
  );
}
