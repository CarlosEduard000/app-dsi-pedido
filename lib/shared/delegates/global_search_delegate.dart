import 'dart:async';
import 'package:flutter/material.dart';

// Definimos un callback genérico que devuelve una lista de T
typedef SearchCallback<T> = Future<List<T>> Function(String query);
// Definimos cómo se construirá cada item de la lista
typedef ResultBuilder<T> = Widget Function(BuildContext context, T item, Function(T) close);

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
            // Aquí delegamos el diseño del item a quien llame la clase
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
    return [
      StreamBuilder(
        initialData: false,
        stream: isLoadingStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data ?? false) {
            return IconButton(
              onPressed: () => query = '',
              icon: const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
            );
          }
          if (query.isNotEmpty) {
            return IconButton(
              onPressed: () => query = '',
              icon: const Icon(Icons.clear),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        clearStreams();
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
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