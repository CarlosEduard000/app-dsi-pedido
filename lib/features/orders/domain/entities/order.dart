import 'package:flutter/material.dart';
import '../../../../config/config.dart';

class Order {
  final int cVent;
  final String id;
  final String clientRuc;
  final String clientName;
  final String status;
  final String paymentType;
  final double amount;
  final String currency;
  final int idVendedor;

  Order({
    required this.cVent,
    required this.id,
    required this.clientRuc,
    required this.clientName,
    required this.status,
    required this.paymentType,
    required this.amount,
    this.currency = 'S/.',
    required this.idVendedor,
  });

  String get amountFormatted => '$currency ${amount.toStringAsFixed(2)}';

  Color get statusColor {
    switch (status.toLowerCase()) {
      case 'aprobado':
      case 'despachado':
        return AppColors.statusApproved;
      case 'pendiente':
      case 'picking':
        return AppColors.statusPending;
      case 'rechazado':
      case 'anulado':
        return AppColors.statusRejected;
      default:
        return AppColors.textGrey;
    }
  }

  String get shortClientName {
    if (clientName.length <= 20) return clientName;
    return '${clientName.substring(0, 17)}...';
  }
}
