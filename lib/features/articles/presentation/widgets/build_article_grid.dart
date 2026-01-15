import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../config/config.dart';
import '../../articles.dart';

class BuildArticleGrid extends StatelessWidget {
  final List<Article> articles;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final FocusNode searchFocusNode;
  final Function(Article) onArticleSeleccionado;
  final ScrollController scrollController;

  const BuildArticleGrid({
    super.key,
    required this.articles,
    required this.scaffoldKey,
    required this.searchFocusNode,
    required this.onArticleSeleccionado,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GridView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      physics: const AlwaysScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        mainAxisExtent: 260,
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
  final Article article;
  final ColorScheme colors;
  final VoidCallback onTap;

  const _ArticleCard({
    required this.article,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color stockColor = article.stock > 0
        ? AppColors.statusStock
        : colors.error;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.outline.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: colors.onSurface.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.05),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: (article.image != null && article.image!.isNotEmpty)
                      ? Image.network(
                          article.image!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.image_not_supported_outlined,
                            color: colors.primary.withOpacity(0.5),
                            size: 40,
                          ),
                        )
                      : Icon(
                          Icons.image_outlined,
                          color: colors.primary.withOpacity(0.5),
                          size: 40,
                        ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.code,
                    style: GoogleFonts.roboto(
                      fontSize: 10,
                      color: colors.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    article.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                      color: colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${article.currency == 'USD' ? '\$' : 'S/'} ${article.price.toStringAsFixed(2)}',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: colors.primary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: stockColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Stock: ${article.stock}',
                          style: GoogleFonts.roboto(
                            fontSize: 10,
                            color: stockColor,
                            fontWeight: FontWeight.bold,
                          ),
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
