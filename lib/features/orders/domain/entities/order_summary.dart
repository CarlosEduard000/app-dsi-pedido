class OrderSummary {
  final double totalAmount;
  final String currency;
  final int qtyAprobados;
  final int qtyPicking;
  final int qtyDespachados;
  final int qtyRechazados;

  OrderSummary({
    required this.totalAmount,
    required this.currency,
    required this.qtyAprobados,
    required this.qtyPicking,
    required this.qtyDespachados,
    required this.qtyRechazados,
  });
}