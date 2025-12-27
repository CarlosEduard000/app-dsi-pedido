import '../../domain/domain.dart';

class OrderMapper {
  static Order jsonToEntity(Map<String, dynamic> json) => Order(
    id: json['id_pedido']?.toString() ?? '0',
    clientRuc: json['ruc_cliente']?.toString() ?? '',
    clientName: json['cliente'] ?? json['nombre_cliente'] ?? 'Sin nombre',
    status: json['estado'] ?? 'Pendiente',
    paymentType: json['tipo_cobranza'] ?? 'CONTADO',
    amount: double.tryParse(json['importe']?.toString() ?? '0') ?? 0.0,
  );
}