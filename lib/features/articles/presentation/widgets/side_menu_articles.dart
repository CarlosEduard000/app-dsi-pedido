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
      // CORRECTO: Recuperamos la cantidad del carrito (Draft), no del Articulo
      final draftItem = ref.read(orderDraftProvider).items[article.articleId];
      _currentQuantity = draftItem?.quantity ?? 0;

      // Consultamos a la API las promociones de este artículo
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(articlePromotionsProvider.notifier).loadPromotions(article);
      });
    }
  }

  void _saveAndClose(Article article) {
    // 1. Guardamos en el carrito (OrderDraft)
    ref
        .read(orderDraftProvider.notifier)
        .addOrUpdateItem(article, _currentQuantity);

    // ERROR ANTERIOR ELIMINADO:
    // ref.read(selectedItemProvider.notifier).update(...) 
    // Ya no actualizamos el 'Article' porque es una entidad inmutable de catálogo.

    FocusScope.of(context).unfocus();
    widget.scaffoldKey.currentState?.closeEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Article? article = ref.watch(selectedItemProvider);
    final promotionsState = ref.watch(articlePromotionsProvider);

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

                // --- ZONA DE PROMOCIONES ---

                if (promotionsState.isLoading)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Center(child: LinearProgressIndicator(minHeight: 2)),
                  ),

                // Tarjeta de REGALO (GiftPromotion)
                if (!promotionsState.isLoading && promotionsState.giftPromotion != null)
                  _GiftPinkCard(
                    colors: colors,
                    giftQuantity: promotionsState.giftPromotion!.giftQuantity,
                    giftName: promotionsState.giftPromotion!.giftArticleId,
                    minBuyCondition: promotionsState.giftPromotion!.minBuyQuantity,
                    unit: article.unit,
                  ),
                
                // Tarjeta de LIQUIDACIÓN (LiquidationRule)
                if (!promotionsState.isLoading && promotionsState.liquidationRule != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 25),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBBB1A).withOpacity(0.1),
                      border: Border.all(color: const Color(0xFFEBBB1A)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "Liquidación activa a partir de ${promotionsState.liquidationRule!.minQuantity} unidades.",
                      style: GoogleFonts.roboto(fontSize: 12, color: colors.onSurface),
                    ),
                  ),

                // Banner por defecto
                if (article.activePromotions.isEmpty)
                  PromotionBanner(colors: colors, quantity: _currentQuantity),

                // -----------------------------

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

class _GiftPinkCard extends StatelessWidget {
  final ColorScheme colors;
  final int giftQuantity;
  final String giftName;
  final int minBuyCondition;
  final String unit;

  const _GiftPinkCard({
    required this.colors,
    required this.giftQuantity,
    required this.giftName,
    required this.minBuyCondition,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    const pinkColor = Color(0xFFF82C9C); 

    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
        border: Border.all(color: pinkColor, width: 1),
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    giftQuantity.toString(),
                    style: GoogleFonts.roboto(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF0A1F44),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    giftName.toUpperCase(),
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0A1F44),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: pinkColor,
                  ),
                  child: const Icon(
                    Icons.star,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: pinkColor.withOpacity(0.1),
              border: const Border(top: BorderSide(color: pinkColor, width: 0.5)),
            ),
            child: Text(
              "Por la compra de $minBuyCondition $unit",
              style: GoogleFonts.roboto(
                fontSize: 11,
                color: pinkColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}