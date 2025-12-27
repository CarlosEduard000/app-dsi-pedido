import 'package:flutter/material.dart';
import 'package:app_dsi_pedido/features/articles/articles.dart';

class TechnicalInfoGrid extends StatelessWidget {
  final Article article;
  final ColorScheme colors;

  const TechnicalInfoGrid({
    super.key,
    required this.article,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _InfoItem(
                icon: Icons.qr_code_scanner,
                label: "Código: ",
                value: article.code,
                colors: colors,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _InfoItem(
                icon: Icons.settings,
                label: "Modelo: ",
                value: article.model,
                colors: colors,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _InfoItem(
                icon: Icons.public,
                label: "Origen: ",
                value: article.origin,
                colors: colors,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _InfoItem(
                icon: Icons.precision_manufacturing,
                label: "Motor: ",
                value: article.motorNumber,
                colors: colors,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ColorScheme colors;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: colors.primary.withValues(alpha: 0.7)),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            "$label$value",
            style: TextStyle(fontSize: 11, color: colors.onSurface),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
