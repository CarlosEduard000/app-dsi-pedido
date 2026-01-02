import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../domain/domain.dart';
import 'clients_repository_provider.dart';

final selectedClientProvider = StateProvider<Client?>((ref) => null);

final selectedPaymentMethodProvider = StateProvider<String?>((ref) => null);

final searchQueryProvider = StateProvider<String>((ref) => '');

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
