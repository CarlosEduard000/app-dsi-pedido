import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildArticleCartList extends StatelessWidget {
  final List<dynamic> articles; // Lista de artículos en el carrito

  const BuildArticleCartList({super.key, required this.articles});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (articles.isEmpty) {
      return Center(
        child: Text(
          'No hay artículos en el carrito',
          style: GoogleFonts.roboto(color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: articles.length,
      separatorBuilder: (context, index) =>
          const Divider(height: 20, thickness: 0.5),
      itemBuilder: (context, index) {
        final article = articles[index];
        return _CartItemTile(article: article, colors: colors);
      },
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final dynamic article;
  final ColorScheme colors;

  const _CartItemTile({required this.article, required this.colors});

  @override
  Widget build(BuildContext context) {
    final bool isGift = article['isGift'] ?? false;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Miniatura del Artículo
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: colors.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.settings_input_component_outlined,
            color: isGift ? Colors.orange : colors.primary,
            size: 30,
          ),
        ),
        const SizedBox(width: 12),

        // Información del Artículo
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                article['title'] ?? '',
                style: GoogleFonts.roboto(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                'Cód: ${article['code']}',
                style: GoogleFonts.roboto(fontSize: 11, color: Colors.grey),
              ),
              if (isGift)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'BONIFICACIÓN',
                    style: GoogleFonts.roboto(
                      fontSize: 9,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Cantidad y Precio
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${article['quantity']} und.',
              style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isGift
                  ? 'S/ 0.00'
                  : 'S/ ${(article['price'] * article['quantity']).toStringAsFixed(2)}',
              style: GoogleFonts.roboto(
                fontSize: 13,
                color: isGift ? Colors.green : colors.secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
