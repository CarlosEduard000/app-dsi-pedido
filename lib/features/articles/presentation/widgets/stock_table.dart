import 'package:flutter/material.dart';

class StockTable extends StatelessWidget {
  final ColorScheme colors;

  const StockTable({super.key, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(1.5),
          1: FlexColumnWidth(3),
          2: FlexColumnWidth(4),
        },
        children: [
          TableRow(
            children: [
              _header("Cant."),
              _header("Almacén"),
              _header("Tienda"),
            ],
          ),
          // Aquí en el futuro podrías pasar una lista de almacenes como parámetro
          _row("220", "Principal A", "Jr. Pedro Tieza 12"),
          _row("85", "Los Incas", "Av. Los Incas 1212"),
        ],
      ),
    );
  }

  Widget _header(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: colors.onSurfaceVariant,
          ),
        ),
      );

  TableRow _row(String c, String a, String t) => TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(
              c,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colors.primary,
                fontSize: 11,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(
              a,
              style: TextStyle(fontSize: 11, color: colors.onSurface),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(
              t,
              style: TextStyle(
                fontSize: 10,
                color: colors.onSurfaceVariant.withOpacity(0.8),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
}