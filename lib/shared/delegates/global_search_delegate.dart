import 'dart:async';
import 'package:flutter/material.dart';

typedef SearchCallback<T> = Future<List<T>> Function(String query);
typedef ResultBuilder<T> =
    Widget Function(BuildContext context, T item, Function(T) close);

class GlobalSearchDelegate<T> extends SearchDelegate<T?> {
  final SearchCallback<T> searchFunction;
  final ResultBuilder<T> resultBuilder;
  List<T> initialData;

  StreamController<List<T>> debouncedResults = StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();
  Timer? _debounceTimer;

  GlobalSearchDelegate({
    required this.searchFunction,
    required this.resultBuilder,
    required this.initialData,
    String? searchLabel,
  }) : super(searchFieldLabel: searchLabel ?? 'Buscar');

  void clearStreams() {
    _debounceTimer?.cancel();
    if (!debouncedResults.isClosed) debouncedResults.close();
    if (!isLoadingStream.isClosed) isLoadingStream.close();
  }

  void _onQueryChanged(String query) {
    if (isLoadingStream.isClosed) return;

    if (query.isEmpty) {
      _debounceTimer?.cancel();
      debouncedResults.add([]);
      isLoadingStream.add(false);
      return;
    }

    isLoadingStream.add(true);
    _debounceTimer?.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      if (debouncedResults.isClosed) return;

      try {
        final results = await searchFunction(query);
        if (debouncedResults.isClosed) return;
        debouncedResults.add(results);
        isLoadingStream.add(false);
      } catch (e) {
        if (!debouncedResults.isClosed) {
          debouncedResults.add([]);
          isLoadingStream.add(false);
        }
      }
    });
  }

  Widget _buildResultsAndSuggestions() {
    return StreamBuilder<List<T>>(
      initialData: query.isEmpty ? initialData : [],
      stream: debouncedResults.stream,
      builder: (context, snapshot) {
        final results = snapshot.data ?? [];

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final item = results[index];
            return resultBuilder(context, item, (selectedItem) {
              clearStreams();
              close(context, selectedItem);
            });
          },
        );
      },
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final iconColor = Theme.of(context).iconTheme.color;

    return [
      StreamBuilder(
        initialData: false,
        stream: isLoadingStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data ?? false) {
            return IconButton(
              onPressed: () => query = '',
              icon: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
                ),
              ),
            );
          }
          if (query.isNotEmpty) {
            return IconButton(
              onPressed: () => query = '',
              icon: Icon(Icons.clear, color: iconColor),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    final iconColor = Theme.of(context).iconTheme.color;
    return IconButton(
      onPressed: () {
        clearStreams();
        close(context, null);
      },
      icon: Icon(Icons.arrow_back_ios_new_rounded, color: iconColor),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildResultsAndSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);
    return _buildResultsAndSuggestions();
  }
}
