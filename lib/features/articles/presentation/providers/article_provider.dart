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

    final requestQuery = state.query;

    try {
      final articles = await repository.getArticles(
        limit: state.limit,
        offset: state.offset,
        query: state.query,
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
  }) => ArticlesState(
    articles: articles ?? this.articles,
    isLoading: isLoading ?? this.isLoading,
    isLastPage: isLastPage ?? this.isLastPage,
    limit: limit ?? this.limit,
    offset: offset ?? this.offset,
    query: query ?? this.query,
  );
}
