import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/shared.dart';
import '../../../clients/presentation/providers/providers.dart';
import '../../../orders/presentation/providers/order_draft_provider.dart';
import '../../articles.dart';

class ArticleCatalogScreen extends ConsumerStatefulWidget {
  static const name = 'article_catalog';
  const ArticleCatalogScreen({super.key});

  @override
  ConsumerState<ArticleCatalogScreen> createState() =>
      _ProductCatalogScreenState();
}

class _ProductCatalogScreenState extends ConsumerState<ArticleCatalogScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode _searchFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(articlesProvider.notifier).loadNextPage();
    });
    _scrollController.addListener(() {
      if ((_scrollController.position.pixels + 200) >=
          _scrollController.position.maxScrollExtent) {
        ref.read(articlesProvider.notifier).loadNextPage();
      }
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final articlesState = ref.watch(articlesProvider);
    final productoSeleccionado = ref.watch(selectedItemProvider);
    final selectedClient = ref.watch(selectedClientProvider);
    final orderDraft = ref.watch(orderDraftProvider);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: colors.surface,
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      endDrawer: (productoSeleccionado != null)
          ? SideMenuArticles(scaffoldKey: scaffoldKey)
          : null,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.menu, color: colors.onSurface),
          onPressed: () {
            _searchFocusNode.unfocus();
            scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: Text(
          'Catálogo',
          style: GoogleFonts.roboto(
            color: colors.onSurface,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined, color: colors.secondary),
            onPressed: () => context.go('/cart_screen'),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHeaderInfo(colors, isDark, selectedClient, articlesState),
          Expanded(
            child: BuildArticleGrid(
              scrollController: _scrollController,
              articles: articlesState.articles,
              scaffoldKey: scaffoldKey,
              searchFocusNode: _searchFocusNode,
              onArticleSeleccionado: (article) {
                ref.read(selectedItemProvider.notifier).state = article;
                scaffoldKey.currentState?.openEndDrawer();
              },
            ),
          ),
          if (articlesState.isLoading && articlesState.articles.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
              ),
            ),
        ],
      ),
      bottomNavigationBar: _buildBottomPurchaseBar(colors, isDark, orderDraft),
    );
  }

  Widget _buildHeaderInfo(
    ColorScheme colors,
    bool isDark,
    dynamic client,
    ArticlesState articlesState,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableInputField(
            hintText: 'Buscar por nombre o código...',
            value: articlesState.query.isEmpty ? null : articlesState.query,
            icon: Icons.search,
            onPressed: () async {
              ref.read(articlesProvider.notifier).onSearchQueryChanged('');

              final Article? selectedArticle = await showSearch<Article?>(
                context: context,
                delegate: GlobalSearchDelegate<Article>(
                  initialData: [],
                  searchLabel: 'Buscar artículos',
                  searchFunction: (query) {
                    return ref
                        .read(articlesRepositoryProvider)
                        .getArticles(query: query);
                  },
                  resultBuilder: (context, article, close) {
                    return ListTile(
                      leading: (article.image != null)
                          ? Image.network(
                              article.image!,
                              width: 40,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.inventory_2,
                                color: colors.onSurfaceVariant,
                              ),
                            )
                          : Icon(
                              Icons.inventory_2,
                              color: colors.onSurfaceVariant,
                            ),
                      title: Text(
                        article.name,
                        style: TextStyle(color: colors.onSurface),
                      ),
                      subtitle: Text(
                        "${article.code} - ${article.brand}",
                        style: TextStyle(color: colors.onSurfaceVariant),
                      ),
                      trailing: Text(
                        "${article.currency == 'USD' ? '\$' : 'S/'} ${article.price.toStringAsFixed(2)}",
                        style: TextStyle(color: colors.primary),
                      ),
                      onTap: () => close(article),
                    );
                  },
                ),
              );

              if (selectedArticle != null) {
                ref
                    .read(articlesProvider.notifier)
                    .onSearchQueryChanged(selectedArticle.name);
              }
            },
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CLIENTE SELECCIONADO',
                    style: GoogleFonts.roboto(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: colors.outline,
                    ),
                  ),
                  Text(
                    client?.name ?? 'NO SELECCIONADO',
                    style: GoogleFonts.roboto(
                      fontSize: 13,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    client?.documentNumber ?? '',
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colors.secondary,
                    ),
                  ),
                ],
              ),
              Material(
                color: colors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                child: IconButton(
                  icon: Icon(Icons.tune, color: colors.primary),
                  onPressed: () => context.go('/client_selection_screen'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPurchaseBar(
    ColorScheme colors,
    bool isDark,
    OrderDraftState draft,
  ) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: colors.surface,
        boxShadow: [
          BoxShadow(
            color: colors.onSurface.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSummaryItem(
                    'Items',
                    '${draft.totalItems}',
                    colors: colors,
                  ),
                  _buildSummaryItem(
                    'Unidades',
                    '${draft.totalUnits}',
                    colors: colors,
                  ),
                  _buildSummaryItem(
                    'Total estimado',
                    'S/ ${draft.totalAmount.toStringAsFixed(2)}',
                    isTotal: true,
                    colors: colors,
                  ),
                ],
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: draft.items.isEmpty
                      ? null
                      : () {
                          _searchFocusNode.unfocus();
                          context.push('/cart_screen');
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Continuar Pedido',
                    style: GoogleFonts.roboto(
                      color: colors.secondary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
    String label,
    String value, {
    bool isTotal = false,
    required ColorScheme colors,
  }) {
    return Column(
      crossAxisAlignment: isTotal
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.roboto(
            fontSize: 10,
            color: colors.outline,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.roboto(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: isTotal ? colors.primary : colors.onSurface,
          ),
        ),
      ],
    );
  }
}
