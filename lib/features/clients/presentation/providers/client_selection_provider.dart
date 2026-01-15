import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../auth/domain/entities/shops_warehouses.dart';
import '../../domain/domain.dart';
import 'clients_repository_provider.dart';

final selectedClientProvider = StateProvider<Client?>((ref) => null);

// CORRECCIÓN: Se quitó .autoDispose para mantener la selección al navegar
final selectedPaymentMethodProvider = StateProvider<String?>(
  (ref) => null,
);

final searchQueryProvider = StateProvider<String>((ref) => '');

// CORRECCIÓN: Se quitó .autoDispose para mantener la selección al navegar
final selectedShopProvider = StateProvider<Shop?>((ref) => null);

// CORRECCIÓN: Se quitó .autoDispose para mantener la selección al navegar
final selectedWarehouseProvider = StateProvider<Warehouse?>(
  (ref) => null,
);

final searchedClientsProvider =
    StateNotifierProvider<SearchedClientsNotifier, List<Client>>((ref) {
      final clientRepository = ref.read(clientsRepositoryProvider);

      return SearchedClientsNotifier(
        searchClients: clientRepository.searchClients,
        ref: ref,
      );
    });

typedef SearchClientsCallback = Future<List<Client>> Function(String query);

class SearchedClientsNotifier extends StateNotifier<List<Client>> {
  final SearchClientsCallback searchClients;
  final Ref ref;

  SearchedClientsNotifier({required this.searchClients, required this.ref})
    : super([]);

  Future<List<Client>> searchClientsByQuery(String query) async {
    if (query.isEmpty) {
      state = [];
      return [];
    }

    final List<Client> clients = await searchClients(query);

    ref.read(searchQueryProvider.notifier).update((state) => query);

    state = clients;

    return clients;
  }
}