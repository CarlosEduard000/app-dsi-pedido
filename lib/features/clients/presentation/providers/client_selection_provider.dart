import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../domain/domain.dart';
import 'clients_repository_provider.dart'; // Asegúrate de importar tu repositorio

// 1. Cliente seleccionado (Ya lo tenías, lo dejamos igual)
final selectedClientProvider = StateProvider<Client?>((ref) => null);

// 2. Término de búsqueda (Para que el texto no se borre al salir)
final searchQueryProvider = StateProvider<String>((ref) => '');

// 3. Lista de clientes encontrados (Para cachear resultados)
final searchedClientsProvider = StateNotifierProvider<SearchedClientsNotifier, List<Client>>((ref) {
  // Obtenemos la referencia al repositorio
  final clientRepository = ref.read(clientsRepositoryProvider);
  
  return SearchedClientsNotifier(
    searchClients: clientRepository.searchClients, 
    ref: ref
  );
});

// Definición de la función de búsqueda
typedef SearchClientsCallback = Future<List<Client>> Function(String query);

// 4. El Notifier que maneja la lógica
class SearchedClientsNotifier extends StateNotifier<List<Client>> {
  
  final SearchClientsCallback searchClients;
  final Ref ref;

  SearchedClientsNotifier({
    required this.searchClients,
    required this.ref,
  }): super([]);

  Future<List<Client>> searchClientsByQuery(String query) async {
    // Si la búsqueda es vacía, no hacemos nada o limpiamos
    if (query.isEmpty) {
      state = [];
      return [];
    }

    // Ejecutamos la búsqueda usando el repositorio
    final List<Client> clients = await searchClients(query);
    
    // Guardamos el término de búsqueda en el otro provider
    ref.read(searchQueryProvider.notifier).update((state) => query);

    // Actualizamos el estado con los clientes encontrados
    state = clients;
    
    return clients;
  }
}