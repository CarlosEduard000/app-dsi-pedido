import 'package:flutter_riverpod/legacy.dart';
import '../../articles.dart';

final articlesProvider = StateNotifierProvider<ArticlesNotifier, ArticlesState>(
  (ref) {
    final repository = ref.watch(articlesRepositoryProvider);
    return ArticlesNotifier(repository: repository);
  },
);

class ArticlesNotifier extends StateNotifier<ArticlesState> {
  final ArticlesRepository repository;

  ArticlesNotifier({required this.repository}) : super(ArticlesState()) {
    loadNextPage();
  }

  Future<void> loadNextPage() async {
    if (state.isLoading || state.isLastPage) return;

    state = state.copyWith(isLoading: true);

    // Guardamos el query actual para verificar integridad después
    final requestQuery = state.query;

    try {
      final articles = await repository.getArticles(
        limit: state.limit,
        offset: state.offset,
        query: state.query,
      );

      // SEGURIDAD: Si el usuario cambió la búsqueda mientras esperábamos, 
      // ignoramos estos resultados viejos.
      if (state.query != requestQuery) return;

      if (articles.isEmpty) {
        state = state.copyWith(isLoading: false, isLastPage: true);
        return;
      }

      // Filtro de duplicados
      final currentIds = state.articles.map((a) => a.id).toSet();
      final newArticles = articles
          .where((a) => !currentIds.contains(a.id))
          .toList();

      // Si todos eran duplicados, asumimos que no hay más datos nuevos
      if (newArticles.isEmpty) {
        state = state.copyWith(isLoading: false, isLastPage: true);
        return;
      }

      state = state.copyWith(
        isLoading: false,
        isLastPage: articles.length < state.limit,
        articles: [...state.articles, ...newArticles],
        offset: state.offset + articles.length,
      );
    } catch (e) {
      // Si falla, solo quitamos el loading para permitir reintentar
      state = state.copyWith(isLoading: false);
    }
  }

  void onSearchQueryChanged(String query) {
    if (state.query == query) return;

    state = state.copyWith(
      query: query,
      offset: 0,
      articles: [],
      isLastPage: false,
      isLoading: false, // Reseteamos loading por seguridad
    );

    loadNextPage();
  }
}

class ArticlesState {
  final List<Article> articles;
  final bool isLoading;
  final bool isLastPage;
  final int limit;
  final int offset;
  final String query;

  ArticlesState({
    this.articles = const [],
    this.isLoading = false,
    this.isLastPage = false,
    this.limit = 10,
    this.offset = 0,
    this.query = '',
  });

  ArticlesState copyWith({
    List<Article>? articles,
    bool? isLoading,
    bool? isLastPage,
    int? limit,
    int? offset,
    String? query,
  }) =>
      ArticlesState(
        articles: articles ?? this.articles,
        isLoading: isLoading ?? this.isLoading,
        isLastPage: isLastPage ?? this.isLastPage,
        limit: limit ?? this.limit,
        offset: offset ?? this.offset,
        query: query ?? this.query,
      );
}