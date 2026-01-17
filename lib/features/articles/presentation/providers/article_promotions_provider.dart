import 'package:flutter_riverpod/legacy.dart';
import '../../articles.dart';

/// 1. El Estado: Agrupa la info de ambas promociones
class ArticlePromotionsState {
  final bool isLoading;
  final GiftPromotion? giftPromotion;
  final LiquidationRule? liquidationRule;

  ArticlePromotionsState({
    this.isLoading = false,
    this.giftPromotion,
    this.liquidationRule,
  });

  ArticlePromotionsState copyWith({
    bool? isLoading,
    GiftPromotion? giftPromotion,
    LiquidationRule? liquidationRule,
  }) => ArticlePromotionsState(
    isLoading: isLoading ?? this.isLoading,
    giftPromotion: giftPromotion ?? this.giftPromotion,
    liquidationRule: liquidationRule ?? this.liquidationRule,
  );
}

/// 2. El Notifier: Gestiona la lógica de qué llamar según el artículo
class ArticlePromotionsNotifier extends StateNotifier<ArticlePromotionsState> {
  final ArticlesPromotionsRepository repository;

  ArticlePromotionsNotifier({required this.repository})
    : super(ArticlePromotionsState());

  /// Carga las promociones basadas en los flags 'activePromotions' del artículo
  Future<void> loadPromotions(Article article) async {
    // Iniciamos carga y limpiamos datos previos para no mostrar info de otro artículo
    state = state.copyWith(
      isLoading: true,
      giftPromotion: null,
      liquidationRule: null,
    );

    GiftPromotion? gift;
    LiquidationRule? liquidation;

    try {
      // Usamos Future.wait para que si tiene ambas, las cargue en paralelo (más rápido)
      final List<Future<void>> tasks = [];

      // -- Lógica para Regalo (Gift) --
      // Asumimos que tu backend manda el string 'GIFT' o el ID que uses
      if (article.activePromotions.contains('GIFT') ||
          article.activePromotions.contains('PROMO_REGALO')) {
        tasks.add(
          repository
              .getGiftPromotionByArticleId(article.articleId)
              .then((val) => gift = val),
        );
      }

      // -- Lógica para Liquidación --
      if (article.activePromotions.contains('LIQUIDATION') ||
          article.activePromotions.contains('PROMO_LIQUIDACION')) {
        tasks.add(
          repository
              .getLiquidationRuleByArticleId(article.articleId)
              .then((val) => liquidation = val),
        );
      }

      // Esperamos a que terminen las peticiones necesarias
      if (tasks.isNotEmpty) {
        await Future.wait(tasks);
      }

      // Actualizamos el estado final
      if (mounted) {
        state = state.copyWith(
          isLoading: false,
          giftPromotion: gift,
          liquidationRule: liquidation,
        );
      }
    } catch (e) {
      // En caso de error, quitamos el loading.
      // Podrías agregar un campo 'errorMessage' al estado si quisieras mostrarlo.
      if (mounted) {
        state = state.copyWith(isLoading: false);
      }
    }
  }

  /// Limpia el estado (útil cuando se cierra el SideMenu)
  void clear() {
    state = ArticlePromotionsState();
  }
}

/// 3. El Provider
final articlePromotionsProvider =
    StateNotifierProvider<ArticlePromotionsNotifier, ArticlePromotionsState>((
      ref,
    ) {
      // Obtenemos el repositorio del otro archivo de providers
      final repository = ref.watch(articlePromotionsRepositoryProvider);
      return ArticlePromotionsNotifier(repository: repository);
    });
