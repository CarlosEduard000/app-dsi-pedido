import '../../domain/domain.dart';

class ClientMapper {
  static Client jsonToEntity(Map<String, dynamic> json) => Client(
    id: json['c_persona'] ?? 0, // Mapeamos c_persona a id
    documentType: json['documento'] ?? '',
    documentNumber: json['numero_documento'] ?? '',
    name: json['nombre'] ?? '',

    // Manejo seguro de Listas de Strings
    addresses: json['direccion'] != null
        ? List<String>.from(json['direccion'].map((x) => x.toString()))
        : [],
    shops: json['tienda'] != null
        ? List<String>.from(json['tienda'].map((x) => x.toString()))
        : [],
    paymentMethods: json['forma_cobro'] != null
        ? List<String>.from(json['forma_cobro'].map((x) => x.toString()))
        : [],
    warehouses: json['almacen'] != null
        ? List<String>.from(json['almacen'].map((x) => x.toString()))
        : [],

    // Mapeo de la lista de objetos CreditLine
    creditLines: json['linea_credito'] != null
        ? List<CreditLine>.from(
            json['linea_credito'].map(
              (x) => CreditLine(
                assigned: double.tryParse(x['asignada'].toString()) ?? 0.0,
                used: double.tryParse(x['usada'].toString()) ?? 0.0,
                available: double.tryParse(x['disponible'].toString()) ?? 0.0,
              ),
            ),
          )
        : [],

    priceCategory: json['categoria_precio'] ?? '',
    classification: json['clasificacion_cliente'] ?? '',
    idVendedor: json['c_vendedor'] ?? 0,
  );
}
