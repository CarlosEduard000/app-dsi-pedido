import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/widgets/widgets.dart';
import '../../../orders/presentation/providers/order_draft_provider.dart';
import '../../articles.dart';

class SideMenuArticles extends ConsumerStatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const SideMenuArticles({super.key, required this.scaffoldKey});

  @override
  ConsumerState<SideMenuArticles> createState() => _SideMenuArticlesState();
}

class _SideMenuArticlesState extends ConsumerState<SideMenuArticles> {
  int _currentQuantity = 0;

  @override
  void initState() {
    super.initState();
    final article = ref.read(selectedItemProvider);
    if (article != null) {
      final draftItem = ref.read(orderDraftProvider).items[article.id];
      _currentQuantity = draftItem?.quantity ?? 0;
    }
  }

  void _saveAndClose(Article article) {
    ref
        .read(orderDraftProvider.notifier)
        .addOrUpdateItem(article, _currentQuantity);

    ref
        .read(selectedItemProvider.notifier)
        .update((state) => state?.copyWith(quantity: _currentQuantity));

    FocusScope.of(context).unfocus();
    widget.scaffoldKey.currentState?.closeEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Article? article = ref.watch(selectedItemProvider);

    if (article == null) {
      return Drawer(
        backgroundColor: colors.surface,
        child: const Center(child: Text("Seleccione un artículo")),
      );
    }

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
      backgroundColor: colors.surface,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                const SizedBox(height: 60),
                Text(
                  article.name,
                  style: GoogleFonts.roboto(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark ? colors.onSurface : colors.secondary,
                  ),
                ),
                Text(
                  "${article.category} - ${article.family} / ${article.subFamily}",
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
                const Divider(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${article.currency == 'USD' ? '\$' : 'S/'} ${article.price.toStringAsFixed(2)}",
                            style: TextStyle(
                              color: colors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            "Stock: ${article.stock} ${article.unit}",
                            style: TextStyle(
                              color: colors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Marca: ${article.brand}",
                            style: TextStyle(
                              color: colors.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    QuantityInput(
                      initialValue: _currentQuantity,
                      onQuantityChanged: (newValue) {
                        setState(() {
                          _currentQuantity = newValue;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                TechnicalInfoGrid(article: article, colors: colors),
                const SizedBox(height: 25),
                if (article.isGift)
                  PromotionBanner(colors: colors, quantity: _currentQuantity),
                const SizedBox(height: 25),
                Text(
                  "Otros Almacenes",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colors.onSurfaceVariant,
                  ),
                ),
                StockTable(colors: colors),
              ],
            ),
          ),
          ArticleFooter(
            article: article,
            colors: colors,
            isDark: isDark,
            currentQuantity: _currentQuantity,
            onConfirm: () => _saveAndClose(article),
          ),
        ],
      ),
    );
  }
}
