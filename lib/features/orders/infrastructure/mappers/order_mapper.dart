import '../../domain/domain.dart';

class OrderMapper {
  
  static Order jsonToEntity(Map<String, dynamic> json) => Order(
    cVent: json['c_vent'] ?? 0,
    id: json['id'].toString(), 
    clientRuc: json['clientRuc'] ?? json['ruc'] ?? 'Sin RUC',
    clientName: json['clientName'] ?? json['razon_social'] ?? 'Cliente Desconocido',
    status: json['status'] ?? json['estado'] ?? 'Pendiente',
    paymentType: json['paymentType'] ?? json['condicion_pago'] ?? 'CONTADO',
    amount: double.tryParse(json['amount'].toString()) ?? 
            double.tryParse(json['total'].toString()) ?? 0.0,
    currency: json['currency'] ?? json['moneda'] ?? 'S/.',
    idVendedor: json['idVendedor'] ?? 0
  );
}