import '../entities/client.dart';

abstract class ClientRepository {
  Future<List<Client>> getClientsByVendedor(
    int idVendedor, {
    int page = 1,
    int limit = 10,
  });

  Future<List<Client>> searchClients(String query, {int limit = 10});

  Future<Client> getClientById(int idCliente);
}
