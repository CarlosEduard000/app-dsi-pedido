import 'package:flutter/material.dart';

class Order {
  final int c_vent;
  final String id;
  final String clientRuc;
  final String clientName;
  final String status; // Ej: 'Aprobado', 'Pendiente', 'Rechazado'
  final String paymentType; // Ej: 'CONTADO', 'CRED 30'
  final double amount;
  final String currency;
  final int idVendedor;

  Order({
    required this.c_vent,
    required this.id,
    required this.clientRuc,
    required this.clientName,
    required this.status,
    required this.paymentType,
    required this.amount,
    this.currency = 'S/.', // Valor por defecto
    required this.idVendedor
  });

  // Getter para mostrar el importe formateado (Ej: S/. 1,200.00)
  String get amountFormatted => '$currency ${amount.toStringAsFixed(2)}';

  // Getter para obtener el color según el estado (Centraliza la lógica visual)
  Color get statusColor {
    switch (status.toLowerCase()) {
      case 'aprobado':
      case 'despachado':
        return Colors.greenAccent;
      case 'pendiente':
      case 'picking':
        return Colors.amber;
      case 'rechazado':
      case 'anulado':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  // Getter para un nombre corto del cliente si es muy largo
  String get shortClientName {
    if (clientName.length <= 20) return clientName;
    return '${clientName.substring(0, 17)}...';
  }
}
