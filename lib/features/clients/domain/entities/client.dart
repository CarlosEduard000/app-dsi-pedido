// lib/features/clients/domain/entities/client.dart

// Clase auxiliar para la Línea de Crédito (Value Object)
class CreditLine {
  final double assigned; // Linea asignada
  final double used; // Linea usada
  final double available; // Linea disponible

  CreditLine({
    required this.assigned,
    required this.used,
    required this.available,
  });
}

// Entidad Principal Cliente
class Client {
  final int id; // c_persona
  final String documentType; // dni, ruc, etc.
  final String documentNumber; // numero de documento
  final String name; // nombre
  final List<String> addresses; // direccion (lista)
  final List<String> shops; // tienda (lista)
  final List<String> paymentMethods; // forma de cobro (lista)
  final List<String> warehouses; // almacen (lista)

  // Aquí usamos la sub-clase que creamos arriba
  final List<CreditLine> creditLines;

  final String priceCategory; // categoria de precio
  final String classification; // clasificacion de cliente
  final int idVendedor; // c_vendedor

  Client({
    required this.id,
    required this.documentType,
    required this.documentNumber,
    required this.name,
    required this.addresses,
    required this.shops,
    required this.paymentMethods,
    required this.warehouses,
    required this.creditLines,
    required this.priceCategory,
    required this.classification,
    required this.idVendedor,
  });

  // OPCIONAL: Getters computados útiles para la UI
  // Por ejemplo, para mostrar el documento completo en una sola línea
  String get fullDocument => '$documentType: $documentNumber';

  // Para obtener el total disponible si tuviera múltiples líneas de crédito
  double get totalCreditAvailable {
    if (creditLines.isEmpty) return 0.0;
    return creditLines.fold(0, (sum, item) => sum + item.available);
  }
}
