import 'package:app_dsi_pedido/features/articles/articles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/shared.dart';

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

  // Lista de productos de prueba
  final List<dynamic> misProductosList = [
    {
      'id': '1',
      'title': 'ALTERNADOR CG300 18P 93MM MTF REY',
      'price': 34.00,
      'stock': 145,
      'code': 'JO958',
    },
    {
      'id': '2',
      'title': 'ALTERNADOR TEKKEN 12 POLOS 25MM TRIFASICO',
      'price': 45.00,
      'stock': 221,
      'code': 'JO532',
    },
    {
      'id': '3',
      'title': 'AMORTIGUADOR DE BARRA DELANTERA (PAR) UND - REY',
      'price': 99.00,
      'stock': 46,
      'code': 'JO123',
    },
  ];

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final productoSeleccionado = ref.watch(selectedItemProvider);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: colors.surface,
      
      // MENU IZQUIERDO: Navegación principal
      drawer: SideMenu(scaffoldKey: scaffoldKey),

      // MENU DERECHO (endDrawer): Detalle del artículo seleccionado
      endDrawer: (productoSeleccionado != null)
          ? SideMenuArticles(scaffoldKey: scaffoldKey)
          : null,

      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: isDark ? Colors.white : const Color(0xFF333333),
          ),
          onPressed: () {
            _searchFocusNode.unfocus();
            // Abre el panel izquierdo (SideMenu)
            scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: Text(
          'Catálogo',
          style: GoogleFonts.roboto(
            color: isDark ? Colors.white : const Color(0xFF333333),
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
          _buildHeaderInfo(colors, isDark),
          Expanded(
            child: BuildArticleGrid(
              articles: misProductosList,
              scaffoldKey: scaffoldKey,
              searchFocusNode: _searchFocusNode,
              onArticleSeleccionado: (prod) {
                // Mapeo a entidad Article
                final article = ArticleMapper.jsonToEntity(prod);

                // Guardamos en el Provider
                ref.read(selectedItemProvider.notifier).state = article;

                // ABRIMOS EL LADO DERECHO (endDrawer)
                scaffoldKey.currentState?.openEndDrawer();
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomPurchaseBar(colors, isDark),
    );
  }

  Widget _buildHeaderInfo(ColorScheme colors, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomInputField(
            hintText: 'Buscar por nombre o código...',
            prefixIcon: Icons.search,
            isSearchStyle: true,
            onFocus: () => setState(() {}),
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
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    'INVERSIONES LA PASCANA S.A.C',
                    style: GoogleFonts.roboto(
                      fontSize: 13,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    '20503225923',
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colors.secondary,
                    ),
                  ),
                ],
              ),
              Material(
                color: colors.primary.withValues(alpha: 0.1),
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

  Widget _buildBottomPurchaseBar(ColorScheme colors, bool isDark) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: colors.surface,
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black54 : Colors.black12,
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
                  _buildSummaryItem('Items', '3'),
                  _buildSummaryItem('Unidades', '20'),
                  _buildSummaryItem(
                    'Total estimado',
                    'S/ 790.00',
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
                  onPressed: () {
                    _searchFocusNode.unfocus();
                    context.push('/cart_screen');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'CONTINUAR PEDIDO',
                    style: GoogleFonts.roboto(
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
    ColorScheme? colors,
  }) {
    return Column(
      crossAxisAlignment:
          isTotal ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.roboto(
            fontSize: 10,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.roboto(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: (isTotal && colors != null)
                ? colors.primary
                : colors?.onSurface,
          ),
        ),
      ],
    );
  }
}