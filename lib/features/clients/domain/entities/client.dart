class CreditLine {
  final double assigned;
  final double used;
  final double available;

  CreditLine({
    required this.assigned,
    required this.used,
    required this.available,
  });
}

class Client {
  final int id;
  final String documentType;
  final String documentNumber;
  final String name;
  final String corporation;
  final List<String> addresses;
  final List<String> paymentMethods;
  final List<CreditLine> creditLines;
  final String priceCategory;
  final String classification;
  final int idVendedor;

  Client({
    required this.id,
    required this.documentType,
    required this.documentNumber,
    required this.name,
    required this.corporation,
    required this.addresses,
    required this.paymentMethods,
    required this.creditLines,
    required this.priceCategory,
    required this.classification,
    required this.idVendedor,
  });

  String get fullDocument => '$documentType: $documentNumber';

  double get totalCreditAvailable {
    if (creditLines.isEmpty) return 0.0;
    return creditLines.fold(0, (sum, item) => sum + item.available);
  }
}
