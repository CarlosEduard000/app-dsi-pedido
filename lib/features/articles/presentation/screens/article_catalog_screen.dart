import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../shared/shared.dart';
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

    final articlesState = ref.watch(articlesProvider);
    final productoSeleccionado = ref.watch(selectedItemProvider);

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
          const CatalogHeader(),
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
      bottomNavigationBar: CatalogBottomBar(searchFocusNode: _searchFocusNode),
    );
  }
}
