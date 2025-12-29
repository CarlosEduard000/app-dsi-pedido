import '../../domain/domain.dart';

class OrderMapper {
  
  static Order jsonToEntity(Map<String, dynamic> json) => Order(
    // Asegúrate de que las llaves ('id', 'ruc', etc) coincidan con tu Postman
    id: json['id'].toString(), 
    clientRuc: json['clientRuc'] ?? json['ruc'] ?? 'Sin RUC',
    clientName: json['clientName'] ?? json['razon_social'] ?? 'Cliente Desconocido',
    status: json['status'] ?? json['estado'] ?? 'Pendiente',
    paymentType: json['paymentType'] ?? json['condicion_pago'] ?? 'CONTADO',
    // Conversión segura a double (por si la API manda un entero o string)
    amount: double.tryParse(json['amount'].toString()) ?? 
            double.tryParse(json['total'].toString()) ?? 0.0,
    currency: json['currency'] ?? json['moneda'] ?? 'S/.',
    idVendedor: json['idVendedor'] ?? 0
  );
}