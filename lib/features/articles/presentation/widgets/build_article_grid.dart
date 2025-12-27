import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildArticleGrid extends StatelessWidget {
  final List<dynamic> articles; // Cambiado de productos a articles
  final GlobalKey<ScaffoldState> scaffoldKey;
  final FocusNode searchFocusNode;
  final Function(dynamic) onArticleSeleccionado;

  const BuildArticleGrid({
    super.key,
    required this.articles,
    required this.scaffoldKey,
    required this.searchFocusNode,
    required this.onArticleSeleccionado,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Dos columnas
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        mainAxisExtent: 250, // Altura fija de cada tarjeta
      ),
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        return _ArticleCard(
          article: article,
          colors: colors,
          onTap: () => onArticleSeleccionado(article),
        );
      },
    );
  }
}

class _ArticleCard extends StatelessWidget {
  final dynamic article;
  final ColorScheme colors;
  final VoidCallback onTap;

  const _ArticleCard({
    required this.article,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.outline.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Espacio para la imagen (o placeholder)
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.05),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Center(
                  child: Icon(Icons.image_outlined, color: colors.primary.withOpacity(0.5), size: 40),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article['code'] ?? '',
                    style: GoogleFonts.roboto(fontSize: 10, color: colors.secondary, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    article['title'] ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w500, height: 1.2),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'S/ ${article['price'].toStringAsFixed(2)}',
                        style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.bold, color: colors.primary),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Stock: ${article['stock']}',
                          style: GoogleFonts.roboto(fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}