import '../../domain/domain.dart';

class ClientRepositoryImpl extends ClientRepository {
  final ClientDatasource datasource;

  ClientRepositoryImpl(this.datasource);

  @override
  Future<List<Client>> getClientsByVendedor(
    int idVendedor, {
    int page = 1,
    int limit = 10,
  }) {
    return datasource.getClientsByVendedor(
      idVendedor,
      page: page,
      limit: limit,
    );
  }

  @override
  Future<Client> getClientById(int idCliente) {
    return datasource.getClientById(idCliente);
  }

  @override
  Future<List<Client>> searchClients(String query, {int limit = 10}) {
    return datasource.searchClients(query, limit: limit);
  }
}
