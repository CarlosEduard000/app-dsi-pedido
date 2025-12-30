import 'dart:async';
import 'package:flutter/material.dart';
import '../../domain/entities/client.dart';

typedef SearchClientsCallback = Future<List<Client>> Function(String query);

class SearchClientDelegate extends SearchDelegate<Client?> {
  final SearchClientsCallback searchClients;
  List<Client> initialClients; // Datos del historial

  StreamController<List<Client>> debouncedClients = StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();

  Timer? _debounceTimer;

  SearchClientDelegate({
    required this.searchClients,
    required this.initialClients,
  }) : super(searchFieldLabel: 'Buscar cliente');

  void clearStreams() {
    _debounceTimer?.cancel();
    if (!debouncedClients.isClosed) debouncedClients.close();
    if (!isLoadingStream.isClosed) isLoadingStream.close();
  }

  void _onQueryChanged(String query) {
    if (isLoadingStream.isClosed) return;
    
    // 1. Si el usuario borró todo, limpiamos INMEDIATAMENTE
    if (query.isEmpty) {
      _debounceTimer?.cancel();
      debouncedClients.add([]); // Emitimos lista vacía
      isLoadingStream.add(false);
      return;
    }

    isLoadingStream.add(true);
    _debounceTimer?.cancel();

    // 2. Debounce para buscar
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      if (debouncedClients.isClosed) return;

      try {
        final clients = await searchClients(query);
        
        if (debouncedClients.isClosed) return;
        debouncedClients.add(clients); // Emitimos nuevos resultados
        isLoadingStream.add(false);
        
      } catch (e) {
        if (!debouncedClients.isClosed) {
           debouncedClients.add([]);
           isLoadingStream.add(false);
        }
      }
    });
  }

  Widget buildResultsAndSuggestions() {
    return StreamBuilder<List<Client>>(
      // LOGICA CORREGIDA:
      // Solo usamos initialClients si el query está VACÍO (recién entramos).
      // Si el usuario ya escribió algo, ignoramos initialData y esperamos al stream.
      initialData: query.isEmpty ? initialClients : [], 
      
      stream: debouncedClients.stream,
      builder: (context, snapshot) {
        final clients = snapshot.data ?? [];

        return ListView.builder(
          itemCount: clients.length,
          itemBuilder: (context, index) => _ClientItem(
            client: clients[index],
            onClientSelected: (context, client) {
              clearStreams();
              close(context, client);
            },
          ),
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
              icon: const SizedBox(
                width: 24, height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
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
    return buildResultsAndSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);
    return buildResultsAndSuggestions();
  }
}

class _ClientItem extends StatelessWidget {
  final Client client;
  final Function onClientSelected;

  const _ClientItem({required this.client, required this.onClientSelected});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    return ListTile(
      title: Text(client.name, style: textStyles.titleMedium),
      subtitle: Text(client.documentNumber),
      leading: const Icon(Icons.person_outline),
      onTap: () => onClientSelected(context, client),
    );
  }
}