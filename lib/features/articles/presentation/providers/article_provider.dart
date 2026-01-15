import 'package:flutter_riverpod/legacy.dart';
import '../../articles.dart';
import '../../../clients/presentation/providers/providers.dart';

final articlesProvider = StateNotifierProvider<ArticlesNotifier, ArticlesState>(
  (ref) {
    final repository = ref.watch(articlesRepositoryProvider);

    final selectedWarehouse = ref.watch(selectedWarehouseProvider);

    return ArticlesNotifier(
      repository: repository,
      warehouseId: selectedWarehouse?.id ?? 0,
    );
  },
);

class ArticlesNotifier extends StateNotifier<ArticlesState> {
  final ArticlesRepository repository;
  final int warehouseId;

  ArticlesNotifier({required this.repository, required this.warehouseId})
    : super(ArticlesState()) {
    if (warehouseId != 0) {
      loadNextPage();
    }
  }

  Future<void> loadNextPage() async {
    if (state.isLoading || state.isLastPage) return;

    state = state.copyWith(isLoading: true);

    final requestQuery = state.query;

    try {
      final articles = await repository.getArticles(
        page: state.page,
        offset: state.limit,
        query: state.query,
        warehouseId: warehouseId,
      );

      if (state.query != requestQuery) return;

      if (articles.isEmpty) {
        state = state.copyWith(isLoading: false, isLastPage: true);
        return;
      }

      final currentIds = state.articles.map((a) => a.id).toSet();
      final newArticles = articles
          .where((a) => !currentIds.contains(a.id))
          .toList();

      state = state.copyWith(
        isLoading: false,
        isLastPage: articles.length < state.limit,
        articles: [...state.articles, ...newArticles],
        page: state.page + 1,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  void onSearchQueryChanged(String query) {
    if (state.query == query) return;

    state = state.copyWith(
      query: query,
      page: 1,
      articles: [],
      isLastPage: false,
      isLoading: false,
    );

    loadNextPage();
  }
}

class ArticlesState {
  final List<Article> articles;
  final bool isLoading;
  final bool isLastPage;
  final int limit;
  final int page;
  final String query;

  ArticlesState({
    this.articles = const [],
    this.isLoading = false,
    this.isLastPage = false,
    this.limit = 10,
    this.page = 1,
    this.query = '',
  });

  ArticlesState copyWith({
    List<Article>? articles,
    bool? isLoading,
    bool? isLastPage,
    int? limit,
    int? page,
    String? query,
  }) => ArticlesState(
    articles: articles ?? this.articles,
    isLoading: isLoading ?? this.isLoading,
    isLastPage: isLastPage ?? this.isLastPage,
    limit: limit ?? this.limit,
    page: page ?? this.page,
    query: query ?? this.query,
  );
}
